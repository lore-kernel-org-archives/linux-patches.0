Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADB9205E3E;
	Sun,  8 Jun 2025 12:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749387358; cv=none; b=V/5bTNAq0+5yjWRPX4RuGvmWN60OCqGw2KfYjg/iIqAmdvucfrINlIewGOY0e3GRkmYcst0Ks81otAIK6C5HymdbazUOyQy5hHQI9MeIU3xwmhUCZc1D6WKImk4LVFfDCJDlORmlFQFHC4ODbqbN0VQWQb1NhykX0Z95c7spna4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749387358; c=relaxed/simple;
	bh=S4rkoZzU6eSmLtfF2FpgxUqqozGAZx207dXJMEWJQnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=YYLMD9PeR9SbHhx0cKwzM+SyaxL5oCnSxOw7ujAuwZhnUufdeDzM6pspyOCcwFItdS73MiBcXhSwJKNSbJXJIFZkIAQZTQXm2bfeQz6Bkbf6Cq5wsXzB4Q5pvEdbCAmbR4VDcaNn4z3kivhgNRVxlXjnmz24AzIuOm2Dz6dAoo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MOgNWwgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MOgNWwgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F61EC4CEEE;
	Sun,  8 Jun 2025 12:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749387358;
	bh=S4rkoZzU6eSmLtfF2FpgxUqqozGAZx207dXJMEWJQnQ=;
	h=From:To:Cc:Subject:Date:From;
	b=MOgNWwgTyD4UVU7zcR/MRd6K65FoP2A+OdHztkjoSEE79a9B5GljpuQ4nZb5i2hZz
	 PAW+JskgrmTT74gAB536/1PWOSO/nuyHexKD7LzswIGF3hvNJmlNpLfZLDMRqZIvd7
	 zpGHVbu+jDt0vCyrV+sxJlVHLk6t+aoJcaWQHjZx7dRkF1ecJEGn7NTPWI2vPHrdIG
	 7wmMMLhIDuonVU7DfIutWULSYPEuevoh4YjCTYMvl44UoEHCgvsSKvsMchTigzqW3v
	 OaRHk8U2/8oBotEqlB1cmpzrxwemU+mT/N2IXAhxBxITuNuQembHRoRoiD9DMsZ+iJ
	 0/JVnZQuRAklA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Philipp Kerling <pkerling@casix.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 1/3] ksmbd: allow a filename to contain special characters on SMB3.1.1 posix extension
Date: Sun,  8 Jun 2025 08:55:53 -0400
Message-Id: <20250608125556.934550-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.185
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit dc3e0f17f74558e8a2fce00608855f050de10230 ]

If client send SMB2_CREATE_POSIX_CONTEXT to ksmbd, Allow a filename
to contain special characters.

Reported-by: Philipp Kerling <pkerling@casix.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of both the commit message and code changes,
examining the Linux kernel repository context:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Nature of the Change

This is a **legitimate bug fix** that addresses a functional issue where
SMB3.1.1 POSIX extension clients cannot create files with characters
that are valid in POSIX filesystems but blocked by ksmbd's Windows-
centric filename validation.

## Code Analysis

### Key Changes:
1. **Early POSIX context detection** (lines 2906-2925): The code now
   checks for SMB2_CREATE_POSIX_CONTEXT early in the function
2. **Conditional validation bypass**: The critical change at lines
   3161-3164 where `ksmbd_validate_filename(name)` is only called when
   `posix_ctxt == false`
3. **Structural improvement**: Moving POSIX context parsing before
   filename validation, which is the logical order

### What Gets Bypassed:
The `ksmbd_validate_filename()` function normally blocks characters like
`"`, `<`, `>`, `|`, `?`, `*`, and control characters. For POSIX
extensions, these restrictions are inappropriate since POSIX filesystems
can safely handle most of these characters.

## Security Assessment

### Low Security Risk:
1. **Limited Scope**: Only affects clients explicitly using SMB3.1.1
   POSIX extensions (`tcon->posix_extensions` must be enabled)
2. **VFS Protection**: Linux VFS layer provides underlying security
   validation
3. **No Path Traversal**: Higher-level path validation still prevents
   `../` sequences
4. **Standards Compliance**: Aligns with Microsoft's SMB3.1.1 POSIX
   extension specification

### Justification for the Change:
- **User Report**: Philipp Kerling reported this as a functional issue
- **Interoperability**: Essential for proper POSIX-aware SMB client
  functionality
- **Standards Adherence**: SMB3.1.1 POSIX extensions are designed to
  allow POSIX filename semantics

## Comparison with Similar Commits

This follows the pattern of other backported ksmbd commits:
- **Similar to Commit #4**: Another filename validation fix that was
  backported (moving leading slash check)
- **Similar scope**: Limited, well-contained change to specific
  subsystem
- **Bug fix nature**: Addresses functional issue rather than adding new
  features

## Stable Tree Criteria Compliance

✅ **Fixes important bug**: Enables legitimate POSIX client functionality
✅ **Small and contained**: Changes only affect POSIX extension code path
✅ **Minimal regression risk**: Protected by existing VFS validation
✅ **Clear side effects**: Well-understood behavior change
✅ **No architectural changes**: Simple conditional logic modification

## Recommendation

This commit represents a **low-risk bug fix** that enables proper
SMB3.1.1 POSIX extension functionality without introducing significant
security vulnerabilities. The change is well-scoped, addresses a
legitimate user issue, and maintains appropriate security boundaries
through existing VFS-level protections.

 fs/ksmbd/smb2pdu.c | 53 +++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b21601c0a457c..76334a983cd25 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2679,7 +2679,7 @@ int smb2_open(struct ksmbd_work *work)
 	int req_op_level = 0, open_flags = 0, may_flags = 0, file_info = 0;
 	int rc = 0;
 	int contxt_cnt = 0, query_disk_id = 0;
-	int maximal_access_ctxt = 0, posix_ctxt = 0;
+	bool maximal_access_ctxt = false, posix_ctxt = false;
 	int s_type = 0;
 	int next_off = 0;
 	char *name = NULL;
@@ -2706,6 +2706,27 @@ int smb2_open(struct ksmbd_work *work)
 		return create_smb2_pipe(work);
 	}
 
+	if (req->CreateContextsOffset && tcon->posix_extensions) {
+		context = smb2_find_context_vals(req, SMB2_CREATE_TAG_POSIX, 16);
+		if (IS_ERR(context)) {
+			rc = PTR_ERR(context);
+			goto err_out2;
+		} else if (context) {
+			struct create_posix *posix = (struct create_posix *)context;
+
+			if (le16_to_cpu(context->DataOffset) +
+				le32_to_cpu(context->DataLength) <
+			    sizeof(struct create_posix) - 4) {
+				rc = -EINVAL;
+				goto err_out2;
+			}
+			ksmbd_debug(SMB, "get posix context\n");
+
+			posix_mode = le32_to_cpu(posix->Mode);
+			posix_ctxt = true;
+		}
+	}
+
 	if (req->NameLength) {
 		if ((req->CreateOptions & FILE_DIRECTORY_FILE_LE) &&
 		    *(char *)req->Buffer == '\\') {
@@ -2737,9 +2758,11 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out2;
 		}
 
-		rc = ksmbd_validate_filename(name);
-		if (rc < 0)
-			goto err_out2;
+		if (posix_ctxt == false) {
+			rc = ksmbd_validate_filename(name);
+			if (rc < 0)
+				goto err_out2;
+		}
 
 		if (ksmbd_share_veto_filename(share, name)) {
 			rc = -ENOENT;
@@ -2854,28 +2877,6 @@ int smb2_open(struct ksmbd_work *work)
 			rc = -EBADF;
 			goto err_out2;
 		}
-
-		if (tcon->posix_extensions) {
-			context = smb2_find_context_vals(req,
-							 SMB2_CREATE_TAG_POSIX, 16);
-			if (IS_ERR(context)) {
-				rc = PTR_ERR(context);
-				goto err_out2;
-			} else if (context) {
-				struct create_posix *posix =
-					(struct create_posix *)context;
-				if (le16_to_cpu(context->DataOffset) +
-				    le32_to_cpu(context->DataLength) <
-				    sizeof(struct create_posix) - 4) {
-					rc = -EINVAL;
-					goto err_out2;
-				}
-				ksmbd_debug(SMB, "get posix context\n");
-
-				posix_mode = le32_to_cpu(posix->Mode);
-				posix_ctxt = 1;
-			}
-		}
 	}
 
 	if (ksmbd_override_fsids(work)) {
-- 
2.39.5

