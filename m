Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABE4247280;
	Tue, 29 Apr 2025 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946857; cv=none; b=mUfvXElvtn28qbb3TVXZxiBT8vPc+/AFBVinHs+I+GSspPEJDGqcX+ejA49wrAKR4EeWfhOZsm1g3IQ0vEsv41K7LDLG81DmkNdHL4xcyH/3J+Ft7ovThmchEjiqujJpAf7QiktgPBfb9QmnL15uU7TtJ6JIQpiCjcDbdZFC3Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946857; c=relaxed/simple;
	bh=25ZLQHut+7QOf6TWr6BgTiY0P+Km21+n/6d1UeBg4fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/cZh/Ap5P1+SjK/EtWShg2fmcF2ys75jIZOWoM7gv5sEQ1k1Uo0ancptBDzxa1soYAgxfiUIg3NN8aQ0jTmVbSSQByjVCjuZMkjOMS+saeJJzvZ75sXeLPm9y2PWJ7FRDnKBbycvV44cg3IjIuAHtF0PJs3idzyS5VKuK9+Ydo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfhblz14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfhblz14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB98C4CEE3;
	Tue, 29 Apr 2025 17:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946857;
	bh=25ZLQHut+7QOf6TWr6BgTiY0P+Km21+n/6d1UeBg4fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfhblz14hbn8RN3RFeLYdFrfJD7wiVhJrGlp4xhT9rGzyNko1GYjPZCDiX9g5OoI7
	 42GX+e/j88FjnKxAuymv4r6R6kwxB1m0LI23wh6QEjdvYr1xZFN3zvnjwlTNTn9yDB
	 w6kgGtbilKqupEOt8j1T+4ViWrb9yUXHovz40t04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.10 091/286] ntb: use 64-bit arithmetic for the MSI doorbell mask
Date: Tue, 29 Apr 2025 18:39:55 +0200
Message-ID: <20250429161111.599992337@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit fd5625fc86922f36bedee5846fefd647b7e72751 upstream.

msi_db_mask is of type 'u64', still the standard 'int' arithmetic is
performed to compute its value.

While most of the ntb_hw drivers actually don't utilize the higher 32
bits of the doorbell mask now, this may be the case for Switchtec - see
switchtec_ntb_init_db().

Found by Linux Verification Center (linuxtesting.org) with SVACE static
analysis tool.

Fixes: 2b0569b3b7e6 ("NTB: Add MSI interrupt support to ntb_transport")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1340,7 +1340,7 @@ static int ntb_transport_probe(struct nt
 	qp_count = ilog2(qp_bitmap);
 	if (nt->use_msi) {
 		qp_count -= 1;
-		nt->msi_db_mask = 1 << qp_count;
+		nt->msi_db_mask = BIT_ULL(qp_count);
 		ntb_db_clear_mask(ndev, nt->msi_db_mask);
 	}
 


