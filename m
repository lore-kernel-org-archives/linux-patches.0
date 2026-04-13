Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30FA313298;
	Mon, 13 Apr 2026 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099147; cv=none; b=lOy8xQ82QzDIG1a3Sc59La4i6IHHHIWStnowuHpjZRxpLsBlae4pMeIagJonA3RJQgk3Y65tuVgp+yW/XFwpWHNFmH2uz73/l0l9ltpgHkOIrcuy/zxZ+qLokWULbgQ39+PMnb/sS8esVQ2aCVAOcXNnVZ8lQ7ygfS43Ybw+ouU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099147; c=relaxed/simple;
	bh=Z3Vy6gFSMKY+7A+Qtrp92BGUw1qPkeujA9Jq/mTe1CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiBu98iUIYKAKkVHi2QOpE0BCpZYTpHRx5gE7Lqh+TQvQMopF3T2Wfoxz2NEG+wE/23VoInZn38dAKuVeDv1BEmhgG0qgSN34JwdXtdVHHcU/9QPNlLc3QUNHF6AKi+KOm5tr7pXB/XIAGMdq3Jq4N45E7XMIwbA4ITAukDcabs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NROb1+bA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NROb1+bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693A9C2BCAF;
	Mon, 13 Apr 2026 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099147;
	bh=Z3Vy6gFSMKY+7A+Qtrp92BGUw1qPkeujA9Jq/mTe1CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NROb1+bAPzwuBEQNxI1lonCAkon4g0RnKgICBU1X6AoduNRfQXFgEU645rByQsI49
	 66C2eDxhHE0QC6pGurg/vZvj1vQdb6nIJVOzkkqhda7jNRU1fXGXaU7m56EN2Hxrkb
	 Pclr0x+i9KX7oyDYz/hBh+qCjOCqRBWVcecDeYJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 228/491] i2c: fsi: Fix a potential leak in fsi_i2c_probe()
Date: Mon, 13 Apr 2026 17:57:53 +0200
Message-ID: <20260413155827.595550676@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit be627abcc0d5dbd5882873bd85fbc18aa3d189ed upstream.

In the commit in Fixes:, when the code has been updated to use an explicit
for loop, instead of for_each_available_child_of_node(), the assumption
that a reference to a device_node structure would be released at each
iteration has been broken.

Now, an explicit of_node_put() is needed to release the reference.

Fixes: 095561f476ab ("i2c: fsi: Create busses for all ports")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/fd805c39f8de51edf303856103d782138a1633c8.1772382022.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-fsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-fsi.c
+++ b/drivers/i2c/busses/i2c-fsi.c
@@ -728,6 +728,7 @@ static int fsi_i2c_probe(struct device *
 		rc = i2c_add_adapter(&port->adapter);
 		if (rc < 0) {
 			dev_err(dev, "Failed to register adapter: %d\n", rc);
+			of_node_put(np);
 			kfree(port);
 			continue;
 		}


