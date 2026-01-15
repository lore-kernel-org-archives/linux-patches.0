Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99FE3C1975;
	Thu, 15 Jan 2026 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498118; cv=none; b=TJkfYjztkXV9n+vOzClzYqR02zYwktBi0tnmjC34QuKmjjM8+E6Il/QxnEsDMGqb7RtnhLTor5Yeg+fG5t4/GdNsVaQYKGJeOp5MeHc6/hyIlj4NgSWct/D++fFFKthVUu7oXXp9lWECewP7UDDpX/0er3uhNj+hCTbzxSQOzH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498118; c=relaxed/simple;
	bh=HAli5doopXajCi6B5vKHZNW1QmTIJPso2NzgWrnC+G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWQWRz3IRKOHh2wquegxVjGK4qbGifuK+SdWXCCGBREmnE3Zdc2UaLrJzC8N7BqAyrXOzUsTUULb10ix9BUohLom3ysQkPDjChBLN0miC95U/h9G2ztByghrZhbLwAzc3zP3Udi0LVg2A1UywpaaWPGKgscW4ZnZ5NoPFz9cnw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiGCPAxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiGCPAxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AF8C16AAE;
	Thu, 15 Jan 2026 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498118;
	bh=HAli5doopXajCi6B5vKHZNW1QmTIJPso2NzgWrnC+G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiGCPAxMKDyx3sYoLsEPAd0WvmH2Gq1lQkR3/c4+eJRJ4xeXkqhONtS7vd9sz/ir3
	 /NnKT+8Nm4JAfZUtKCHSB/cHPzOZwynJHtqC3E3vXdvhKeRCRItT0UVcI11ryoxcr4
	 jkMpRFALLDZJ/PzoddI2L0QdaK2rXM54AFPGhAhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 312/554] parisc: Do not reprogram affinitiy on ASP chip
Date: Thu, 15 Jan 2026 17:46:18 +0100
Message-ID: <20260115164257.524296930@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit dca7da244349eef4d78527cafc0bf80816b261f5 upstream.

The ASP chip is a very old variant of the GSP chip and is used e.g. in
HP 730 workstations. When trying to reprogram the affinity it will crash
with a HPMC as the relevant registers don't seem to be at the usual
location.  Let's avoid the crash by checking the sversion. Also note,
that reprogramming isn't necessary either, as the HP730 is a just a
single-CPU machine.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/gsc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -154,7 +154,9 @@ static int gsc_set_affinity_irq(struct i
 	gsc_dev->eim = ((u32) gsc_dev->gsc_irq.txn_addr) | gsc_dev->gsc_irq.txn_data;
 
 	/* switch IRQ's for devices below LASI/WAX to other CPU */
-	gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
+	/* ASP chip (svers 0x70) does not support reprogramming */
+	if (gsc_dev->gsc->id.sversion != 0x70)
+		gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
 
 	irq_data_update_effective_affinity(d, &tmask);
 


