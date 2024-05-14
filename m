Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA19118026;
	Tue, 14 May 2024 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686447; cv=none; b=bCdE3di/JP87ljyFTjP6T3X3vUM6ly1G34d5xsETThEObSb+fK1/xvVY+qD7Fcv+uMP0oMozmN96crW8dszE3JK6ybr0weJBZAtM+Y6uNFgXuTBvbVxG4dYFejPCyF79456Gt9HXo2i3dMiV1+h+q2qcvgVn52yMkvO8NqksONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686447; c=relaxed/simple;
	bh=4PM8PaQ6eKe0ij/wX76kE/8sfffO5CDI3ruBixeyBx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAXJWVr5aBbEoT+c4qMlAU+P5sfQPNxo9U6CkGLupGNbTNCdcm6BFZRSw4QggrO6SHamO85gRgvj7maIo5SzFAsNWV2YPUtH5/3gypo2HY6Oj5gQGW7iEAIsSECY9PwTfD2ZZMfpu7s5kTS3gvLACqxXd31Jw+1mjQ6rNSQuBo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1B4ZJmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1B4ZJmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A07C2BD10;
	Tue, 14 May 2024 11:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686447;
	bh=4PM8PaQ6eKe0ij/wX76kE/8sfffO5CDI3ruBixeyBx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1B4ZJmRlMhHvbOlvzkGi884PsgOU90kk+bj5A2eIlsWw54owqzTOUZHUr0xAfj+C
	 DL9RG9OiUYCYt/x3ZOglDNB4Qd5aJW29QbTLH2dd4rQLMsbujxW6fQhlFJguSlyRBc
	 CKufTSSq2XkJdHKForhXf1wM9GvX2s2AuRYTxdCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/236] spi: Merge spi_controller.{slave,target}_abort()
Date: Tue, 14 May 2024 12:18:23 +0200
Message-ID: <20240514101025.722108465@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 6c6871cdaef96361f6b79a3e45d451a6475df4d6 ]

Mixing SPI slave/target handlers and SPI slave/target controllers using
legacy and modern naming does not work well: there are now two different
callbacks for aborting a slave/target operation, of which only one is
populated, while spi_{slave,target}_abort() check and use only one,
which may be the unpopulated one.

Fix this by merging the slave/target abort callbacks into a single
callback using a union, like is already done for the slave/target flags.

Fixes: b8d3b056a78dcc94 ("spi: introduce new helpers with using modern naming")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/809c82d54b85dd87ef7ee69fc93016085be85cec.1667555967.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/spi/spi.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 6edf8a2962d4a..0ce659d6fcb75 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -676,8 +676,10 @@ struct spi_controller {
 			       struct spi_message *message);
 	int (*unprepare_message)(struct spi_controller *ctlr,
 				 struct spi_message *message);
-	int (*slave_abort)(struct spi_controller *ctlr);
-	int (*target_abort)(struct spi_controller *ctlr);
+	union {
+		int (*slave_abort)(struct spi_controller *ctlr);
+		int (*target_abort)(struct spi_controller *ctlr);
+	};
 
 	/*
 	 * These hooks are for drivers that use a generic implementation
-- 
2.43.0



