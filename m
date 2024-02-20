Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F1476C9C;
	Tue, 20 Feb 2024 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463669; cv=none; b=P+1723CQvNwC7tjfY+p8sJIdS91dMTKtjp90if0M/cIHYhWvi1NeJ2DLASDsNZr05GAOiWoeTP+E97A7qmtousUzwqbPsCvj+YEp8+kHCaIkXGnPIWF9inw6RyCbbY2vEK0K5GWnRUy8k70ljgHOAcm3Knp8ymN2L3Vi/i3ecpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463669; c=relaxed/simple;
	bh=pqaELFGf+TdG7Yw+dEbbe0vFcqjn3VzzPOi7GieLD6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEwKRmHjqrd15L4P0VkXjtuH2IdY3WtreWCmvwhqL4H1NcuDP3lKrZN26TOEve60Xy6xe3OZPOynssjHDje/sdY4ifJDqUouKlftfc8Y6Vd8kGU8lHi7AzuC9qgJIJpZ1Ndx8bqRlN+4dQYfn5EA7GNyOQuQbhEnpdBZT29jHVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVIc/5qU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVIc/5qU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BD8C433F1;
	Tue, 20 Feb 2024 21:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463669;
	bh=pqaELFGf+TdG7Yw+dEbbe0vFcqjn3VzzPOi7GieLD6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVIc/5qUmCR8e178QY111C47vo4AThsNGelXMVaCVEziCw5bdghhDtdOnl94OfDpK
	 +JxP/ohZacSMocOQf+vTfyCufv+PuAPkRYIjtDog6DgjACLUpXrXs81tYtQ/XZoO2l
	 0QxE8KOTcHq/D9pcMcow2p+Y6Xt4LS4l2sw4fDKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/331] media: ir_toy: fix a memleak in irtoy_tx
Date: Tue, 20 Feb 2024 21:53:23 +0100
Message-ID: <20240220205640.327644382@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



