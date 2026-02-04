Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6A42E92BC;
	Wed,  4 Feb 2026 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216592; cv=none; b=qDdUIwAKgXBc4mFgJ4eUQcC5/KEDGprags5IrKJK+9VAuqbOr9a1ydt6N8v4767tcSXGlxsqelo3zLKdTwzppLwDV8dDpObYoSKqt8akBqHVCVgLtrtbVtZjjpOEpYBS8J387Lu6/GGACY6IHd7p2FR28DzQ+YWTKC7fsA992Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216592; c=relaxed/simple;
	bh=fb7iBes+zu354m62/te8IDItj63iIPnMpROGyrZ24bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IP+XfQGtmYBagvJgZBaqKEfqMcZAVb+tjRkoQcvEu4tHs+QwN+68tGe2UCRGpXdyIz2lw0ONMpItSzo/Sx2K4782Gqdg0RxmGxc7mX2uCcEP/HZSOF5QtIqxENbO/35/bP4C/9Js0BqoHIApw/1WNsuNxlaqJCKW65sbq4nmo2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLTsqMoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLTsqMoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEA7C19423;
	Wed,  4 Feb 2026 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216591;
	bh=fb7iBes+zu354m62/te8IDItj63iIPnMpROGyrZ24bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLTsqMoXe3Ob1ld/ArWJDr0HmO3NRvXnFZ8dmdCckBk7GqVhRD29obteC+w05hRfs
	 nuC6zjdqpr6nl90JD2xM5v0RmGjAXcNsDmzudvT533j3x8BeIJUpXTSkcOgfFpEVic
	 +O4ZKX9N6rUmQhm9WCYcvDoFzrhfUnbLjkloqtQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 132/161] scsi: be2iscsi: Fix a memory leak in beiscsi_boot_get_sinfo()
Date: Wed,  4 Feb 2026 15:39:55 +0100
Message-ID: <20260204143856.492441722@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 4747bafaa50115d9667ece446b1d2d4aba83dc7f upstream.

If nonemb_cmd->va fails to be allocated, free the allocation previously
made by alloc_mcc_wrb().

Fixes: 50a4b824be9e ("scsi: be2iscsi: Fix to make boot discovery non-blocking")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1019,6 +1019,7 @@ unsigned int beiscsi_boot_get_sinfo(stru
 					      &nonemb_cmd->dma,
 					      GFP_KERNEL);
 	if (!nonemb_cmd->va) {
+		free_mcc_wrb(ctrl, tag);
 		mutex_unlock(&ctrl->mbox_lock);
 		return 0;
 	}


