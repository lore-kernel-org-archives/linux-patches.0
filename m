Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A898A359709;
	Wed,  3 Dec 2025 16:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778888; cv=none; b=eDxsT16A/AG83c0rrhkJ7fsNEe6SrQGj+/4o1owF6MHAIT1u8eyKXPH0jOS9qNlaQm2McL4/G8EPwMJGI6XmHPAerhnWw+u+YNGTQjNUdJk+FzIQ8ePmdA5FvT5v7DQL5ZA7Ry/wfj8vZb8NNARPp6yPfa2mgyNb2GghschD2U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778888; c=relaxed/simple;
	bh=/XkI6JRtucdqeUiAMOQhXgm3FrVID9VGt8yH1nz6o10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E+d9K2JufVIc8Cd18bhLs7UfdsrMwhUo+5uubQOXv4+bRPE+oJGbdrXj6nEFCVvo2WHuJTcZo5f6AemS+2HoBwGg8ePLTOJeKFmQxMlgvv1EyrlNvBPIWGl7znkQ8mn3S3W1kG38d4r9s4w3s2pQVn4X+v3sxoHgZaxQSb51cMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Njn/0dl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Njn/0dl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB007C4CEF5;
	Wed,  3 Dec 2025 16:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778888;
	bh=/XkI6JRtucdqeUiAMOQhXgm3FrVID9VGt8yH1nz6o10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Njn/0dl+NRQZMmbQgKA0FuHEe3gTg0RAweK0xLVPYYzKV+vTjGQDgR2BREXqeVyWj
	 Hlyq6lo1ig7y51k3THE0jWbBq+SKzR1YhkeZjrjyv+AfcpOeAjZWowW62D+moAeti2
	 7Y/fauBf9ldyMEgZyzm92Ec7FFcQ5JYjPTnLtQPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/568] soc: ti: pruss: dont use %pK through printk
Date: Wed,  3 Dec 2025 16:21:32 +0100
Message-ID: <20251203152444.035187395@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit a5039648f86424885aae37f03dc39bc9cb972ecb ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250811-restricted-pointers-soc-v2-1-7af7ed993546@linutronix.de
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/pruss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index 6882c86b3ce54..dd5d4675d26f4 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -270,7 +270,7 @@ static int pruss_probe(struct platform_device *pdev)
 		pruss->mem_regions[i].pa = res.start;
 		pruss->mem_regions[i].size = resource_size(&res);
 
-		dev_dbg(dev, "memory %8s: pa %pa size 0x%zx va %pK\n",
+		dev_dbg(dev, "memory %8s: pa %pa size 0x%zx va %p\n",
 			mem_names[i], &pruss->mem_regions[i].pa,
 			pruss->mem_regions[i].size, pruss->mem_regions[i].va);
 	}
-- 
2.51.0



