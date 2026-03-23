Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EB63B6C0A;
	Mon, 23 Mar 2026 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278213; cv=none; b=e9Cbro46aHTuBsKYxHTr45P059CsaaGD1AAuI0xj+rnJ6Fm1JyVS3VbdWDb0gwcmA8OKH8OJ8Eg+YhEYTAmgu0Bd9H0MRGbF0xdcy8kKMDOa/CE4Y90jHN+aJR6hoB0qJ1qYSNMQ7JqUuu/9LSPdDJDQiTcMBeJDlfxwXuZht1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278213; c=relaxed/simple;
	bh=VKLwxMKue+jlLlndP93Oq4dJOvL3ItPCo8yVHyuzmgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0Bi1DqD7V5SO90jI+6OiICmVv/l1UAW5HRmjbdM5OpyQDGPWIq6JJEU2okMA7FJ6GfmaElUcpiF1JjqmNdW3nvlJJkUrGM7nh6Kq7pwO/2CoaVFgkg/8w9YsMzvHcGboDZs6EsdKkoqZCDX2eqtgkx+sGQVXAMPWKTsprSQ05I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vn7N1Prf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vn7N1Prf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBAAC4CEF7;
	Mon, 23 Mar 2026 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278212;
	bh=VKLwxMKue+jlLlndP93Oq4dJOvL3ItPCo8yVHyuzmgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vn7N1Prf1K/GpM6Z77auGyXWaCyNuu7pXojGFQP1qpwmNPRMONj1Px5p/J/TsIfga
	 +OObCFhIYdlInzFq0MrmtJEcMavuMnPWZIG1bdV11BfEvbJeZhrpEJGovfsM0QQmG5
	 ra811rfPS5VHZ/3/h5fMb82sYRzR85hcEwLz9ziY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.6 193/567] apparmor: Fix double free of ns_name in aa_replace_profiles()
Date: Mon, 23 Mar 2026 14:41:53 +0100
Message-ID: <20260323134538.626504179@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

commit 5df0c44e8f5f619d3beb871207aded7c78414502 upstream.

if ns_name is NULL after
1071         error = aa_unpack(udata, &lh, &ns_name);

and if ent->ns_name contains an ns_name in
1089                 } else if (ent->ns_name) {

then ns_name is assigned the ent->ns_name
1095                         ns_name = ent->ns_name;

however ent->ns_name is freed at
1262                 aa_load_ent_free(ent);

and then again when freeing ns_name at
1270         kfree(ns_name);

Fix this by NULLing out ent->ns_name after it is transferred to ns_name

Fixes: 145a0ef21c8e9 ("apparmor: fix blob compression when ns is forced on a policy load")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1115,6 +1115,7 @@ ssize_t aa_replace_profiles(struct aa_ns
 				goto fail;
 			}
 			ns_name = ent->ns_name;
+			ent->ns_name = NULL;
 		} else
 			count++;
 	}


