Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044294;
	b=UwqaI8ZWs3a36N1PphA1Hg4Cpn6hqTsWlPvG3iuRKS5wqkNZUeCYIwK03TGuhH4RpEg5
	 b0HTVETwzldN3teqv1OKpoG+vbRvd5rVl83GtiGVKsVXvAwBADKb23seVQP8vFF9/Kank
	 PleZeW+3pjipNdwUuhykGvNshbd0cwXO9lSk9YvZyATUjWUCEjcBYtkDcVf5jpBc5bUbD
	 1ovIfOHGsQcsMcYu/DhhlJGBvI06QET8g2IqoIBO5mSdqedl0Jr6KOTvv24joHtAOOAeI
	 6zIZVPNQCJmqlFT5dE3et4RjOlhKXiQhEcTyLk2EzNIbcSqFfVCb8akoaybkxigPW9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r6ciUVyl901FQ3R/brHOMF5yZOcfOsebA25nh/vnMz8=;
	b=CdY0sdlGxfXniLLHV97m+giLXZifM3HdDJdG2hPiKCs6bg2iSOuV1l57PgpR6VKMWoi7
	 0gEXg33HCdkSgg4TluTP1k4ydESq42LTT2PS94ZTNoT0XXg4Dh7j+dRjkDD3x1aRnQyWF
	 +LLzYBhJXu0o0SQvZGzJOiiFUe4WouNp65929IQZlHXaqxGVKw2A8seVz/tIfvLAmlhB9
	 dYNFkTge1PshnuYd8+2r/gHviznfJsy0UZDIiqvzFY90XyHeXgcK+PL62rO7pLES1YGT0
	 AhLnBTvpUiTDC2coFRslqHeV7CmGS2GAb7ftx5IgcLq7lcbSuOm6Eu/M+I6WMiivuDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kZbSAyXG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52BD606A320;
	Wed, 18 Nov 2026 23:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kZbSAyXG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219DD1F000C4;
	Wed, 18 Nov 2026 23:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044294;
	bh=r6ciUVyl901FQ3R/brHOMF5yZOcfOsebA25nh/vnMz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZbSAyXGKtOr4i+Ysv0jzFG+zvAnm3viDT0gyNTXrsvt0x68oYiongiVLgV7g/NCj
	 MhU8sTfA2DiAkvlhy55chilNInqd5/vPBJFsAvOMB8mPuV/3vU4qdo4yIV5vB0nn70
	 vvTn4bpFzGdla2W4UtC9cz2PgH7zeViyTn9bgftc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 0513/2857] ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()
Date: Wed, 18 Nov 2026 15:25:47 +0100
Message-ID: <20261118150219.933452401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Kobakhia <gkobakhi@asu.edu>

commit eb96e2a0e817807c48dc8387ca6a5249fdeae3a0 upstream.

When the large dacl_offset is provided, dacl_offset + sizeof(struct
smb_acl) overflows on 32-bit builds and the check is passed,
Which makes le16_to_cpu(ppdacl_ptr->size) read out-of-bounds. This
only happens for dacl_offset in range [0xFFFFFFF8, 0xFFFFFFFF]. So
the oob read is max 8 bytes preceding the allocated ppntsd.

    unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
    int ppdacl_size, ntacl_size = ppntsd_size - dacl_offset;

    if (!dacl_offset ||
	(dacl_offset + sizeof(struct smb_acl) > ppntsd_size))
	    goto out;

Commit beff0bc9d69b ("ksmbd: fix overflow in dacloffset bounds check")
fixes similar checks in other functions. But leaves this one out,
because it is only valid for 32-bit builds.

Reproduced on 32-bit ARM with KASAN, by a client sending SMB2
SET_INFO(SEC) with dacloffset=0xfffffff8, then QUERY_INFO(SEC) on the
same file:

 BUG: KASAN: slab-out-of-bounds in build_sec_desc (fs/smb/server/smbacl.c:1105)
 Read of size 2 at addr c2a273fa by task kworker/1:1/35
 CPU: 1 UID: 0 PID: 35 Comm: kworker/1:1 Not tainted 7.3.0-rc2+ #5
 Workqueue: ksmbd-io handle_ksmbd_work
 Call trace:
  kasan_check_range from build_sec_desc (fs/smb/server/smbacl.c:1105)
  build_sec_desc from smb2_query_info (fs/smb/server/smb2pdu.c:7676)
  smb2_query_info from handle_ksmbd_work (fs/smb/server/server.c:160)
  handle_ksmbd_work from process_one_work (kernel/workqueue.c:3401)
  process_one_work from worker_thread (kernel/workqueue.c:3473)
  worker_thread from kthread (kernel/kthread.c:436)

Add overflow check.

Fixes: 8f0541186e9a ("ksmbd: fix heap-based overflow in set_ntacl_dacl()")
Cc: stable@vger.kernel.org
Assisted-by: LLM claude
Tested-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1080,9 +1080,12 @@ int build_sec_desc(struct user_namespace
 			struct smb_acl *ppdacl_ptr;
 			unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
 			int ppdacl_size, ntacl_size = ppntsd_size - dacl_offset;
+			size_t dacl_struct_end;
 
 			if (!dacl_offset ||
-			    (dacl_offset + sizeof(struct smb_acl) > ppntsd_size))
+			    check_add_overflow(dacl_offset, sizeof(struct smb_acl),
+					       &dacl_struct_end) ||
+			    dacl_struct_end > (size_t)ppntsd_size)
 				goto out;
 
 			ppdacl_ptr = (struct smb_acl *)((char *)ppntsd + dacl_offset);


