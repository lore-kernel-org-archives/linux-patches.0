Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED51D1A6195;
	Tue, 30 Jul 2024 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358530; cv=none; b=bWDxyUhA+2aILuptR4gHF7bKj5+LOTkk2aGjWAN66VDW0Qg02tsvQPY0KS9XPjtE7BD+erJDdlD7mhGE8RI5ZOnKA5zioxl9L9fpP3o7+aMLyJ4cVThAc5k/mClsVkue2h1HfRw6aYx3M96mAGXPrVdvXzWe5fHOoyDkUjTkW6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358530; c=relaxed/simple;
	bh=GjZfosucJwojO8kVMZcqns6pyXcBs2bMozZRus6QxmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvAlL9d8zeGQLGOn6nHqeOKnTGV7IipW9lm4BsayL3qJT1HBtzUnu5lM/0JFiuGsqD/3MUUwZgM9KrA2q+ibrINyHZJZ8EEaakMZNJm0W2xiqrYvMYjumOkoeop5YIIrKnTpbgHs5emYf7TP0a0zAAxV0R+efdY0YTe0euvkQnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V602y7ay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V602y7ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E43C32782;
	Tue, 30 Jul 2024 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358529;
	bh=GjZfosucJwojO8kVMZcqns6pyXcBs2bMozZRus6QxmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V602y7ayOcvZK/jEg+rcv7eqMZnDAJKs4S2PaT1xtpxOrlTm+6+fjtAjAWKcGz8s2
	 LdFZPEnNWh63o7Ut22v9BIrUnpqAnpD05DPeEh6U4yglHEPSdrGNDqEU7u46TzR2gF
	 KcB7GjnU5kquzyAxg0RcHUSCdK9kLfytnpKE4JkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 367/809] mfd: omap-usb-tll: Use struct_size to allocate tll
Date: Tue, 30 Jul 2024 17:44:03 +0200
Message-ID: <20240730151739.150569571@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 40176714c818b0b6a2ca8213cdb7654fbd49b742 ]

Commit 16c2004d9e4d ("mfd: omap-usb-tll: Allocate driver data at once")
changed the memory allocation of 'tll' to consolidate it into a single
allocation, introducing an incorrect size calculation.

In particular, the allocation for the array of pointers was converted
into a single-pointer allocation.

The memory allocation used to occur in two steps:

tll = devm_kzalloc(dev, sizeof(struct usbtll_omap), GFP_KERNEL);
tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk *) * tll->nch,
                           GFP_KERNEL);

And it turned that into the following allocation:

tll = devm_kzalloc(dev, sizeof(*tll) + sizeof(tll->ch_clk[nch]),
                   GFP_KERNEL);

sizeof(tll->ch_clk[nch]) returns the size of a single pointer instead of
the expected nch pointers.

This bug went unnoticed because the allocation size was small enough to
fit within the minimum size of a memory allocation for this particular
case [1].

The complete allocation can still be done at once with the struct_size
macro, which comes in handy for structures with a trailing flexible
array.

Fix the memory allocation to obtain the original size again.

Link: https://lore.kernel.org/all/202406261121.2FFD65647@keescook/ [1]
Fixes: 16c2004d9e4d ("mfd: omap-usb-tll: Allocate driver data at once")
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Fixes: commit 16c2004d9e4d ("mfd: omap-usb-tll: Allocate driver data at once")
Link: https://lore.kernel.org/r/20240626-omap-usb-tll-counted_by-v2-1-4bedf20d1b51@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/omap-usb-tll.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index b6303ddb013b0..f68dd02814638 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -230,8 +230,7 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 		break;
 	}
 
-	tll = devm_kzalloc(dev, sizeof(*tll) + sizeof(tll->ch_clk[nch]),
-			   GFP_KERNEL);
+	tll = devm_kzalloc(dev, struct_size(tll, ch_clk, nch), GFP_KERNEL);
 	if (!tll) {
 		pm_runtime_put_sync(dev);
 		pm_runtime_disable(dev);
-- 
2.43.0



