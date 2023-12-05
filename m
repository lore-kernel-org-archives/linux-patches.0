Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11676FB1;
	Tue,  5 Dec 2023 03:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyqfV1Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CFCC433C8;
	Tue,  5 Dec 2023 03:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747080;
	bh=V7yPsAMubyTa4VMKhM4Y8LAKr2ObLcXWO1CxAJqwPP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyqfV1QevLai1GI+eY6WA8zxajpijVFfXcZsszKbHE1cyG6XrwIY0teBBnfY6W42X
	 WiVBmr0xtjDMdLWrfQ/x2uTWL2rrfXCCTrEQQQ02ar7eHmhPOlLoyDCqkOlc3WSHc/
	 gPX/9OFJUpFtEM1BdZEPsezZjNHL/tWypILK3NfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Hugo Villeneuve <hugo@hugovil.com>
Subject: [PATCH 6.1 052/107] serial: sc16is7xx: Put IOControl register into regmap_volatile
Date: Tue,  5 Dec 2023 12:16:27 +0900
Message-ID: <20231205031534.586077627@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

commit 77a82cebf0eb023203b4cb2235cab75afc77cccf upstream.

According to the IOControl register bits description in the page 31 of
the product datasheet, we know the bit 3 of IOControl register is
softreset, this bit will self-clearing once the reset finish.

In the probe, the softreset bit is set, and when we read this register
from debugfs/regmap interface, we found the softreset bit is still
setting, this confused us for a while. Finally we found this register
is cached, to read the real value from register, we could put it
into the regmap_volatile().

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20230724034727.17335-1-hui.wang@canonical.com
Cc: Hugo Villeneuve <hugo@hugovil.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -486,6 +486,7 @@ static bool sc16is7xx_regmap_volatile(st
 	case SC16IS7XX_TXLVL_REG:
 	case SC16IS7XX_RXLVL_REG:
 	case SC16IS7XX_IOSTATE_REG:
+	case SC16IS7XX_IOCONTROL_REG:
 		return true;
 	default:
 		break;


