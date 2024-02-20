Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E00446C9;
	Tue, 20 Feb 2024 21:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464755; cv=none; b=sp04Te6KQXQOQra9Ww4H7t8qKN7ty3FX2akD6gkphg1NDCFYDTFK3YZnPLXvgKdSbaiorECmem7FWMwedHwo43zbhPfJb7zpsyb8FTyOKqfDibeOd3OWEqopiTz3mKzXPoraymsNMek8LUkik96r2hM7fRWK+tdSVhWVs39rrqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464755; c=relaxed/simple;
	bh=ptarE3S9pjht4yh2+dLm8Fma5yyh+u525ZRLB/qIflg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZj6gVv4vygEW72f3xeBhRdEnIRTRAjIHPJknj0ATYPxOs8hXf0aYEZybwNsn62NxEAnn1NwGLmB0SUvgWiNiQGTzMF5M5pjH+PGCUdE2OHtxlHR2X38ASE93+6kcQz8D9wfrR9JpRh810y5DeEVzWs8TueDmI9vtkbRNVM51s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxgNpHac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxgNpHac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C02C433C7;
	Tue, 20 Feb 2024 21:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464755;
	bh=ptarE3S9pjht4yh2+dLm8Fma5yyh+u525ZRLB/qIflg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxgNpHacjijtzgjgdcQ6ISvKsGaraBiGpqHnAf1KWtGGVZm8IaYb9GNuswv6+J1eW
	 nGqrZOFNmYQwaSqUmVJFqK1jaer0E7dEGK6q7ywA0eH5i1L/xDU6MeishSqtS5F8Kz
	 YANFdmNi2/morePRBi8nVBuB7j+qk8Za8Yl8Tgz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 097/309] media: ir_toy: fix a memleak in irtoy_tx
Date: Tue, 20 Feb 2024 21:54:16 +0100
Message-ID: <20240220205636.223653004@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit dc9ceb90c4b42c6e5c6757df1d6257110433788e ]

When irtoy_command fails, buf should be freed since it is allocated by
irtoy_tx, or there is a memleak.

Fixes: 4114978dcd24 ("media: ir_toy: prevent device from hanging during transmit")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 196806709259..69e630d85262 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -332,6 +332,7 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
 			    sizeof(COMMAND_SMODE_EXIT), STATE_COMMAND_NO_RESP);
 	if (err) {
 		dev_err(irtoy->dev, "exit sample mode: %d\n", err);
+		kfree(buf);
 		return err;
 	}
 
@@ -339,6 +340,7 @@ static int irtoy_tx(struct rc_dev *rc, uint *txbuf, uint count)
 			    sizeof(COMMAND_SMODE_ENTER), STATE_COMMAND);
 	if (err) {
 		dev_err(irtoy->dev, "enter sample mode: %d\n", err);
+		kfree(buf);
 		return err;
 	}
 
-- 
2.43.0



