Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DDE45BE4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVNy6AIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B93C433C9;
	Wed, 15 Nov 2023 22:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085799;
	bh=E+Yy8KGE9OmuA8CKBCeOrQn1S1IRq/4+4BeDOvKu2ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVNy6AIoAnsNxAz/2NkQZV4Mdz1NC39QmdTNQ+dcGfnWbi/IzOMbM9QzAYMWndm+H
	 zvrj3WzII3StB28u3QHgWLpYlhiL+11fTO4Fu3UhDs9V0g8RjQB7KlRTpseDDL4dQc
	 Sumbqn+xwU2oP1fL2VfdxoRC4j4WeZGkfcBB4lss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mars Cheng <marscheng@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Yen-lin Lai <yenlinlai@google.com>,
	Daniel Mentz <danielmentz@google.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/119] scsi: ufs: core: Leave space for \0 in utf8 desc string
Date: Wed, 15 Nov 2023 17:00:51 -0500
Message-ID: <20231115220134.519263307@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mentz <danielmentz@google.com>

[ Upstream commit a75a16c62a2540f11eeae4f2b50e95deefb652ea ]

utf16s_to_utf8s does not NULL terminate the output string. For us to be
able to add a NULL character when utf16s_to_utf8s returns, we need to make
sure that there is space for such NULL character at the end of the output
buffer. We can achieve this by passing an output buffer size to
utf16s_to_utf8s that is one character less than what we allocated.

Other call sites of utf16s_to_utf8s appear to be using the same technique
where they artificially reduce the buffer size by one to leave space for a
NULL character or line feed character.

Fixes: 4b828fe156a6 ("scsi: ufs: revamp string descriptor reading")
Reviewed-by: Mars Cheng <marscheng@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Yen-lin Lai <yenlinlai@google.com>
Signed-off-by: Daniel Mentz <danielmentz@google.com>
Link: https://lore.kernel.org/r/20231017182026.2141163-1-danielmentz@google.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9d13226d2324a..363adf489079a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3265,7 +3265,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		 */
 		ret = utf16s_to_utf8s(uc_str->uc,
 				      uc_str->len - QUERY_DESC_HDR_SIZE,
-				      UTF16_BIG_ENDIAN, str, ascii_len);
+				      UTF16_BIG_ENDIAN, str, ascii_len - 1);
 
 		/* replace non-printable or non-ASCII characters with spaces */
 		for (i = 0; i < ret; i++)
-- 
2.42.0



