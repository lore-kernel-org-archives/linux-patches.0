Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828919;
	b=L4EMpQK34gU9b5hQmMUzR0AinJXaJpldg9AXMtRYHc7QszPMpxWdppdfV65M0My3LYq2
	 lQ3R817rFChiLDnRer5zc8w5pAaV/yTxmongM90ClcffD1HW2ofgcwD2+31xH/VWjDvvo
	 D89eNDt+5aS8HM4HRU7cnE3fcNURc/HkVMn1AKmoPjV5JqY8k1zaEuvR33MLsvYu+ph6x
	 T1UGbK2fBSPWLr3AhWct0BoS5k20V+wgsGjqlb/qjpwtU2Zlj5HFMTeCe5pQtsPRES2bb
	 6XRMJxE/6Pme7JGVj+44V1sOJcJotRgO/jlqEqSKffRqNj5roYLYwzMA24c8APfGQsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=27ujz9Xskzi9OrmFUigshnHkEroxN38ZgvvEXyc9iVI=;
	b=sGYbvlDjro+9pDCtnzMOZmXb9xVVAKk35V0YeOdrIrMacv3igWXNYxndmkbeRBFiqX0E
	 RLbiwKoA+I2bHSj8cB9mpKqBG/XBED0qj5eCl1IbzZVzqu8kA/ccQ+pkFAespiIyCkv8b
	 yOC9rPGYXWm+QGHRFVw2xoymeAqZgsrTmAQH/sDrzvKfisCW+AuevskiObJ8SjUWYLTSG
	 FHRF8QroCDmqa/ATLTNjOcdHdlyTPzacFSdfxLnmM20MV4VP1YP+QsLxpnKvxflGg3ECh
	 VgaZRt2a8I8RPvUsI+PHGAOZaYH6sJIguBWSWSEEFdhhxoO99DEZAfKKcC1ss4ssSaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0Z0NCQ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDE4607031B;
	Wed,  4 Nov 2026 21:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0Z0NCQ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1689F1F000C1;
	Wed,  4 Nov 2026 21:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828919;
	bh=27ujz9Xskzi9OrmFUigshnHkEroxN38ZgvvEXyc9iVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0Z0NCQ5Kh+z8O3TaXtYs/pUPlZSDji5IQrPQHZD8ukxv1ybEeli9ULHZPRkyxlk+
	 QgQAJawts82Jqn6oyyHwctEsGsyqER5v+TPilh4uTTTud2Y4Gr5VJtWmuzRTBTGrp7
	 vv5sb+0oYCprVg3DGcriaePnl5KfBWyxTB5P6tQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 326/547] xfs: abort dirtree repair if the live update hook dies
Date: Wed,  4 Nov 2026 16:08:30 -0500
Message-ID: <20261104211047.485304222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 07732dea4f5d0410e1566b81a58a1154bf9dcb29 upstream.

LOLLM notices that if the live update hook for the directory tree repair
code hits an error, it will set dl->aborted and stops working.  If the
repair code ever sees that condition, it ought to bail out immediately
instead of continuing with obsolete data.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -831,6 +831,11 @@ xrep_dirtree(
 	 */
 	mutex_lock(&dl->lock);
 	do {
+		if (dl->aborted) {
+			error = -EIO;
+			break;
+		}
+
 		/*
 		 * Decide what we're going to do, then do it.  An -ESTALE
 		 * return here means the scan results are invalid and we have


