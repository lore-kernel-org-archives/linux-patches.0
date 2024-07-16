Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C937C19DF88;
	Tue, 16 Jul 2024 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144898; cv=none; b=LtIbZGqF/1ETV6Cfe02H3CXcE4xQ0GdLtMHog/8t3kA7Qt/QOKf9qQR7mgvnw2etwYReSgBBg025nf3QWfdux5Q131Kk5K7WSeeHyl5AmWWEs1n/XNOHhS3Np8ky3hw8Qq3LolNh8OMlBbz6BP1Ov4nUzL1HmbOoePEkZ65JqEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144898; c=relaxed/simple;
	bh=F4QWM/Ub1UKNvqEJZP8G7PEbh0wi1wxMNm98vBztfUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuY05YGKMec8RCYaiQH6tX8gIbSlg+JhcSFr8GzDzGsEQ+Ryh5sw4LcDomcapnydyDlIPVDd6YQpLUx1yhaUgZbz9AjIEvfm5ojAA6LLaUs1rPAGTvtmPNVsPLqmGQF7l7etPAVvv9buLEITEiwBQWiBhpDzxpqBGHqD8tA4z+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXtKpcmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXtKpcmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5017BC116B1;
	Tue, 16 Jul 2024 15:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144898;
	bh=F4QWM/Ub1UKNvqEJZP8G7PEbh0wi1wxMNm98vBztfUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXtKpcmcHMkqXqagY+v2fd+AhhouUvqD7D1+3kn+4O6Hg0E1cD8fudoPZYtHVRzPA
	 HeFwX4TijS72lwbb9Vq1Td0dDRyHcnoLHBhVRB4M+ADYvTGLO4H49hJdiNGeXSRRf7
	 9vNKXafCTuK/CgEvyws/q9C0z2vr+dq+0NnbidFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 025/143] spi: dont unoptimize message in spi_async()
Date: Tue, 16 Jul 2024 17:30:21 +0200
Message-ID: <20240716152756.956606946@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit c86a918b1bdba78fb155184f8d88dfba1e63335d ]

Calling spi_maybe_unoptimize_message() in spi_async() is wrong because
the message is likely to be in the queue and not transferred yet. This
can corrupt the message while it is being used by the controller driver.

spi_maybe_unoptimize_message() is already called in the correct place
in spi_finalize_current_message() to balance the call to
spi_maybe_optimize_message() in spi_async().

Fixes: 7b1d87af14d9 ("spi: add spi_optimize_message() APIs")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20240708-spi-mux-fix-v1-1-6c8845193128@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index c349d6012625a..a1958e86f75c8 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -4423,8 +4423,6 @@ int spi_async(struct spi_device *spi, struct spi_message *message)
 
 	spin_unlock_irqrestore(&ctlr->bus_lock_spinlock, flags);
 
-	spi_maybe_unoptimize_message(message);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(spi_async);
-- 
2.43.0



