Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB75330B3F;
	Fri, 17 Oct 2025 15:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715304; cv=none; b=jj3xCUZGOVHtfjK+ch2lbNTTgDyOTh8dAoBg7R8Swy0i2ysS6HIcr7RGAYSRuO9VpRya0ThbxKjQIvYChYFqPZkc0Sst98ltuMapTbqzGywTmjBnEjqU+LHqcGxqfcHzvYqbPjT3WngVP8TJafi3KWAjjZ9U34FAonRMq5TkkWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715304; c=relaxed/simple;
	bh=pUZmdwm6OjVsJZJhRE/qmUnDLo7xpZkOUNXGz2l3IXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+fUHm3f6rdy7O5uc37vlFNVqmEsDdBDSRrdiGJlzLIOURTD2QyFnjS5TM4bPvojVlbgiJ1BFaUFhrT+S8w2vOutc+rrax2Hfj0scf74C1zS7liW1D3zegCzlxl+ysdH/7WPQtBtKWv6zdLerItGgCV6fzFCesCmkD07vRtrD6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJ1Antth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJ1Antth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8BEC4CEE7;
	Fri, 17 Oct 2025 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715304;
	bh=pUZmdwm6OjVsJZJhRE/qmUnDLo7xpZkOUNXGz2l3IXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJ1AntthCBtnh7LhzAyGzs1b/qABLXYqN+ImmyXMgMjL5rKtN4HcEj5FBWpJ1Uive
	 D3O5z8/nLecaT2UAUeqNkZtaDBZLAmU1uTvNQ4T2Crww9utqlLk7h2idRgimoIV+QU
	 E59NmHt/2Q7CVJajnDarVDZJE7BSxB5mILsGOHmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 170/371] media: i2c: mt9p031: fix mbus code initialization
Date: Fri, 17 Oct 2025 16:52:25 +0200
Message-ID: <20251017145208.081524346@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

commit 075710b670d96cf9edca1894abecba7402fe4f34 upstream.

The mediabus code is device dependent, but the probe() function
thought that device_get_match_data() would return the code directly,
when in fact it returned a pointer to a struct mt9p031_model_info.

As a result, the initial mbus code was garbage.

Tested with a BeagleBoard xM and a Leopard Imaging LI-5M03 sensor board.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Fixes: a80b1bbff88b ("media: mt9p031: Refactor format handling for different sensor models")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/mt9p031.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -1092,6 +1092,7 @@ static int mt9p031_parse_properties(stru
 static int mt9p031_probe(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
+	const struct mt9p031_model_info *info;
 	struct mt9p031 *mt9p031;
 	unsigned int i;
 	int ret;
@@ -1112,7 +1113,8 @@ static int mt9p031_probe(struct i2c_clie
 
 	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
 	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
-	mt9p031->code = (uintptr_t)device_get_match_data(&client->dev);
+	info = device_get_match_data(&client->dev);
+	mt9p031->code = info->code;
 
 	mt9p031->regulators[0].supply = "vdd";
 	mt9p031->regulators[1].supply = "vdd_io";


