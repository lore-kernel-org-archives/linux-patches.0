Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B2F1E0083;
	Wed,  6 Nov 2024 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898524; cv=none; b=XAVzzYkCzSdaUsotgCiQUIqY/NzPQequ2U7FrsvpU3z9EphArV1K2kForBb8NbllanVJRKAxtST5ja+RCvws7pinYAR+tBuxXAI1nR5F9KyFbh/3uiFEN9dgrXgHe3uuvQlj4EiBT/GS5vNk1BNN8IpDjp7oGPacbr0Q3I2KA8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898524; c=relaxed/simple;
	bh=ADdzv+aWu3NsAVKcSaaKRT3GSAWLA8KgRGJlV7h+ilE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0ygRRzuxXvf/cBcZuo1p2ugoj28u0RoBCyQ4WArwd/sGAAjCl/yIsgSkDzdnr392GocCOZ+ABJuHoQ3BUwNDjbqSJLvWKOwZZzHtHj/+BZv7yHxfrBn5G5dvPFxbW4KAfIbYlGKPWpUhGcIVWHOyallgc30ThEYUlBqUdqBK1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZIu9zML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZIu9zML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D40C4CED3;
	Wed,  6 Nov 2024 13:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898524;
	bh=ADdzv+aWu3NsAVKcSaaKRT3GSAWLA8KgRGJlV7h+ilE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZIu9zMLtkgKWQPks3VDPEMfLKyo9biEJ03eNtg8EyzocIdzZaID2HR3O+SaHzgTk
	 a+wS0lJEUY1NFHuP8IOnUeqFg9tOEQJWu/DxsMfnKQ+FA3fb2VOkdVGQ4QJITo0gKS
	 39ii5+SScg2EaleI9mu/m+VYG5vGZsDAgCZE43Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/462] scsi: aacraid: Rearrange order of struct aac_srb_unit
Date: Wed,  6 Nov 2024 13:02:03 +0100
Message-ID: <20241106120337.201686994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 6e5860b0ad4934baee8c7a202c02033b2631bb44 ]

struct aac_srb_unit contains struct aac_srb, which contains struct sgmap,
which ends in a (currently) "fake" (1-element) flexible array.  Converting
this to a flexible array is needed so that runtime bounds checking won't
think the array is fixed size (i.e. under CONFIG_FORTIFY_SOURCE=y and/or
CONFIG_UBSAN_BOUNDS=y), as other parts of aacraid use struct sgmap as a
flexible array.

It is not legal to have a flexible array in the middle of a structure, so
it either needs to be split up or rearranged so that it is at the end of
the structure. Luckily, struct aac_srb_unit, which is exclusively
consumed/updated by aac_send_safw_bmic_cmd(), does not depend on member
ordering.

The values set in the on-stack struct aac_srb_unit instance "srbu" by the
only two callers, aac_issue_safw_bmic_identify() and
aac_get_safw_ciss_luns(), do not contain anything in srbu.srb.sgmap.sg, and
they both implicitly initialize srbu.srb.sgmap.count to 0 during
memset(). For example:

        memset(&srbu, 0, sizeof(struct aac_srb_unit));

        srbcmd = &srbu.srb;
        srbcmd->flags   = cpu_to_le32(SRB_DataIn);
        srbcmd->cdb[0]  = CISS_REPORT_PHYSICAL_LUNS;
        srbcmd->cdb[1]  = 2; /* extended reporting */
        srbcmd->cdb[8]  = (u8)(datasize >> 8);
        srbcmd->cdb[9]  = (u8)(datasize);

        rcode = aac_send_safw_bmic_cmd(dev, &srbu, phys_luns, datasize);

During aac_send_safw_bmic_cmd(), a separate srb is mapped into DMA, and has
srbu.srb copied into it:

        srb = fib_data(fibptr);
        memcpy(srb, &srbu->srb, sizeof(struct aac_srb));

Only then is srb.sgmap.count written and srb->sg populated:

        srb->count              = cpu_to_le32(xfer_len);

        sg64 = (struct sgmap64 *)&srb->sg;
        sg64->count             = cpu_to_le32(1);
        sg64->sg[0].addr[1]     = cpu_to_le32(upper_32_bits(addr));
        sg64->sg[0].addr[0]     = cpu_to_le32(lower_32_bits(addr));
        sg64->sg[0].count       = cpu_to_le32(xfer_len);

But this is happening in the DMA memory, not in srbu.srb. An attempt to
copy the changes back to srbu does happen:

        /*
         * Copy the updated data for other dumping or other usage if
         * needed
         */
        memcpy(&srbu->srb, srb, sizeof(struct aac_srb));

But this was never correct: the sg64 (3 u32s) overlap of srb.sg (2 u32s)
always meant that srbu.srb would have held truncated information and any
attempt to walk srbu.srb.sg.sg based on the value of srbu.srb.sg.count
would result in attempting to parse past the end of srbu.srb.sg.sg[0] into
srbu.srb_reply.

After getting a reply from hardware, the reply is copied into
srbu.srb_reply:

        srb_reply = (struct aac_srb_reply *)fib_data(fibptr);
        memcpy(&srbu->srb_reply, srb_reply, sizeof(struct aac_srb_reply));

This has always been fixed-size, so there's no issue here. It is worth
noting that the two callers _never check_ srbu contents -- neither
srbu.srb nor srbu.srb_reply is examined. (They depend on the mapped
xfer_buf instead.)

Therefore, the ordering of members in struct aac_srb_unit does not matter,
and the flexible array member can moved to the end.

(Additionally, the two memcpy()s that update srbu could be entirely
removed as they are never consumed, but I left that as-is.)

Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20240711215739.208776-1-kees@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3fa03230f6ba3..6120f7890d903 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2024,8 +2024,8 @@ struct aac_srb_reply
 };
 
 struct aac_srb_unit {
-	struct aac_srb		srb;
 	struct aac_srb_reply	srb_reply;
+	struct aac_srb		srb;
 };
 
 /*
-- 
2.43.0



