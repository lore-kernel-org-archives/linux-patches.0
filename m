Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651953D6CAC;
	Fri, 24 Apr 2026 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037585; cv=none; b=QAEWniBifJzeA4EYXGLrD0Kx8wkiDOF8UjD2uYoQ1ziIjw04M9M5ZeDlYS45Nt5AhrcKCtCOpejlnmB1Ral6z9h5PDE+wG6+O0RgxC4eerVkHlRr+UQlcEOA+hUwO0N9T2hLlMauYR8uqmwtqeNBTzk51t6ZV101GY21wBlWLxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037585; c=relaxed/simple;
	bh=/f7dCbdv8ERmPss5SnrdoMyPL2ZgrgbwURWBHX2cXoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tObFPqtm57On3mVnayhlzQ14c1QUxWKy3UcbInpA/NJ8c+Qz10PapW9rScIg1y84OliAMaFl0DrAoB1qlekqCRAKX05RcKB2+avRkSxg1cTHXnQtV4lW5pIijVn/mA5MAzPMScYscFeo5vl1nqhGOZWZcdJQyIqBDUm4CoGNLTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmGGgpK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmGGgpK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA782C19425;
	Fri, 24 Apr 2026 13:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037585;
	bh=/f7dCbdv8ERmPss5SnrdoMyPL2ZgrgbwURWBHX2cXoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmGGgpK7lX6VoeSbL31RdVmjHDpfCKIvtDOXbLno6+rUpuZahJMWB6zbEdxZ8BHXL
	 qviaS+qnUdPW/ciYhcIBLF5IHDTgK1b7L4H9OR1Qe0mnqMwtPzwrX3hTfWj+5cSH5j
	 od8A7hpH4sJiyYbd16SluWyq2DkDpwK4P47uN2Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 27/42] ksmbd: validate response sizes in ipc_validate_msg()
Date: Fri, 24 Apr 2026 15:30:52 +0200
Message-ID: <20260424132426.040332215@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit d6a6aa81eac2c9bff66dc6e191179cb69a14426b upstream.

ipc_validate_msg() computes the expected message size for each
response type by adding (or multiplying) attacker-controlled fields
from the daemon response to a fixed struct size in unsigned int
arithmetic.  Three cases can overflow:

  KSMBD_EVENT_RPC_REQUEST:
      msg_sz = sizeof(struct ksmbd_rpc_command) + resp->payload_sz;
  KSMBD_EVENT_SHARE_CONFIG_REQUEST:
      msg_sz = sizeof(struct ksmbd_share_config_response) +
               resp->payload_sz;
  KSMBD_EVENT_LOGIN_REQUEST_EXT:
      msg_sz = sizeof(struct ksmbd_login_response_ext) +
               resp->ngroups * sizeof(gid_t);

resp->payload_sz is __u32 and resp->ngroups is __s32.  Each addition
can wrap in unsigned int; the multiplication by sizeof(gid_t) mixes
signed and size_t, so a negative ngroups is converted to SIZE_MAX
before the multiply.  A wrapped value of msg_sz that happens to
equal entry->msg_sz bypasses the size check on the next line, and
downstream consumers (smb2pdu.c:6742 memcpy using rpc_resp->payload_sz,
kmemdup in ksmbd_alloc_user using resp_ext->ngroups) then trust the
unverified length.

Use check_add_overflow() on the RPC_REQUEST and SHARE_CONFIG_REQUEST
paths to detect integer overflow without constraining functional
payload size; userspace ksmbd-tools grows NDR responses in 4096-byte
chunks for calls like NetShareEnumAll, so a hard transport cap is
unworkable on the response side.  For LOGIN_REQUEST_EXT, reject
resp->ngroups outside the signed [0, NGROUPS_MAX] range up front and
report the error from ipc_validate_msg() so it fires at the IPC
boundary; with that bound the subsequent multiplication and addition
stay well below UINT_MAX.  The now-redundant ngroups check and
pr_err in ksmbd_alloc_user() are removed.

This is the response-side analogue of aab98e2dbd64 ("ksmbd: fix
integer overflows on 32 bit systems"), which hardened the request
side.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Fixes: a77e0e02af1c ("ksmbd: add support for supplementary groups")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_config.c |    6 ------
 fs/smb/server/transport_ipc.c    |   16 +++++++++++++---
 2 files changed, 13 insertions(+), 9 deletions(-)

--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -56,12 +56,6 @@ struct ksmbd_user *ksmbd_alloc_user(stru
 		goto err_free;
 
 	if (resp_ext) {
-		if (resp_ext->ngroups > NGROUPS_MAX) {
-			pr_err("ngroups(%u) from login response exceeds max groups(%d)\n",
-					resp_ext->ngroups, NGROUPS_MAX);
-			goto err_free;
-		}
-
 		user->sgid = kmemdup(resp_ext->____payload,
 				     resp_ext->ngroups * sizeof(gid_t),
 				     KSMBD_DEFAULT_GFP);
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -13,6 +13,7 @@
 #include <net/genetlink.h>
 #include <linux/socket.h>
 #include <linux/workqueue.h>
+#include <linux/overflow.h>
 
 #include "vfs_cache.h"
 #include "transport_ipc.h"
@@ -497,7 +498,9 @@ static int ipc_validate_msg(struct ipc_m
 	{
 		struct ksmbd_rpc_command *resp = entry->response;
 
-		msg_sz = sizeof(struct ksmbd_rpc_command) + resp->payload_sz;
+		if (check_add_overflow(sizeof(struct ksmbd_rpc_command),
+				       resp->payload_sz, &msg_sz))
+			return -EINVAL;
 		break;
 	}
 	case KSMBD_EVENT_SPNEGO_AUTHEN_REQUEST:
@@ -516,8 +519,9 @@ static int ipc_validate_msg(struct ipc_m
 			if (resp->payload_sz < resp->veto_list_sz)
 				return -EINVAL;
 
-			msg_sz = sizeof(struct ksmbd_share_config_response) +
-					resp->payload_sz;
+			if (check_add_overflow(sizeof(struct ksmbd_share_config_response),
+					       resp->payload_sz, &msg_sz))
+				return -EINVAL;
 		}
 		break;
 	}
@@ -526,6 +530,12 @@ static int ipc_validate_msg(struct ipc_m
 		struct ksmbd_login_response_ext *resp = entry->response;
 
 		if (resp->ngroups) {
+			if (resp->ngroups < 0 ||
+			    resp->ngroups > NGROUPS_MAX) {
+				pr_err("ngroups(%d) from login response exceeds max groups(%d)\n",
+				       resp->ngroups, NGROUPS_MAX);
+				return -EINVAL;
+			}
 			msg_sz = sizeof(struct ksmbd_login_response_ext) +
 					resp->ngroups * sizeof(gid_t);
 		}


