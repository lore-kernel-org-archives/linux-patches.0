Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555D613C90B;
	Tue, 25 Jun 2024 10:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309733; cv=none; b=WR2oICpO8zQJ8UyY8JcTy7GJXwI5YhHIIUuU5yo8Cv+wPBCMRW3yJ6Sx/HOwFBnogH3danXdAHthrg0EzBeah8CAelP+ERcgmXteNVEz6jgXjid5hX5m/jwFgMfPNI1u6x7gbCHFtNOezkcXXApwmy+47Sa1gJrQEV/spohZ0kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309733; c=relaxed/simple;
	bh=tWt8izKD7mo0h1/wLsJ44Vq8IkCCwBi2tYLit0+fNj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jly8MqI/pAT047X8M3v73BIUE585HiFJ+smypsvfwPg0ipZKaGogJhg+0K9ATb15wGkbsrWTL+HeNOU7SWtrfrJUicQApvQ6owCCoemot8ED890p272QHPzrmrbx+xEsUlFHiBkajpthWRH9ycaF6WH51ql4LXFxypGHN0pNmdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GD7xWcJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GD7xWcJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC7BC4AF09;
	Tue, 25 Jun 2024 10:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309733;
	bh=tWt8izKD7mo0h1/wLsJ44Vq8IkCCwBi2tYLit0+fNj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GD7xWcJhqeSm+8WEfKz6nE1YvDSVg1nCn9IMnd+ZDDwEUwSSFkf85vXu5DfGKMY1C
	 IxFdDC87Pbhfj5cAayEELrvG/eXP5746bvZC2AZRsMM6FQqZoDE2GW5vi6A4hZX6sD
	 plTJKnVWikUjd7o/cUKxvxnKK1agKlvSh/r62cI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 116/131] spi: stm32: qspi: Clamp stm32_qspi_get_mode() output to CCR_BUSWIDTH_4
Date: Tue, 25 Jun 2024 11:34:31 +0200
Message-ID: <20240625085530.344732729@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Patrice Chotard <patrice.chotard@foss.st.com>

commit 63deee52811b2f84ed2da55ad47252f0e8145d62 upstream.

In case usage of OCTAL mode, buswidth parameter can take the value 8.
As return value of stm32_qspi_get_mode() is used to configure fields
of CCR registers that are 2 bits only (fields IMODE, ADMODE, ADSIZE,
 DMODE), clamp return value of stm32_qspi_get_mode() to 4.

Fixes: a557fca630cc ("spi: stm32_qspi: Add transfer_one_message() spi callback")
Cc: stable@vger.kernel.org
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://msgid.link/r/20240618132951.2743935-3-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-stm32-qspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -350,7 +350,7 @@ static int stm32_qspi_wait_poll_status(s
 
 static int stm32_qspi_get_mode(u8 buswidth)
 {
-	if (buswidth == 4)
+	if (buswidth >= 4)
 		return CCR_BUSWIDTH_4;
 
 	return buswidth;


