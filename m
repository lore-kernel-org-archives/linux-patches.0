Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A73253351;
	Tue, 29 Apr 2025 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947506; cv=none; b=FyzuDVO3uuZG6sF7A3rCM7U6rZQF0mYl6mj+Rg6XMbW6qIjE54I7rIEbokqrce6nRssMUtSJ70oy/B8ntSIjo9hO6N0qVTTh6TsFP9Qt44ftEPQpvsg/ex6OXnxibtmbOvozeHglPYPEXb9mQ/ilKa2+5JhTqjuxhI63fm3YAXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947506; c=relaxed/simple;
	bh=il8mq01fjRpBEWEE/2csSCC+o0qTFrgta/fT3FQIdTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjWOM1c7RjpyxAzepHa8E528tp8rQypTnH9d7AytanxKUwrdBLroNHmVYITgdOexgoCYHlCaa6YQemUUqG+DXGoztBSwbLxh+WWhGog7Wug/Q3H6CdtfdBX0AC77g4oxOoqsHFcUUarQiLaszj61ACwqc/J2V9kRY45TdGK+JEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQbJNm+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQbJNm+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83546C4AF0C;
	Tue, 29 Apr 2025 17:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947505;
	bh=il8mq01fjRpBEWEE/2csSCC+o0qTFrgta/fT3FQIdTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQbJNm+PPeukwPa28P+0y9JcLUaNCOJtbqaccFsMozvT40Pa44OC8aMW42/LtMRvX
	 Ihg3II1SdsMX+cthrgYY+xvO2bqvrQzRZFB7mNPKodnvfkE0Fg2aHrTeEKTui6Gue8
	 TcEWt1Hw2txsrEigT9S5RQBIbXq7c/iRg6Nu3nYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/280] media: ov08x40: Add missing ov08x40_identify_module() call on stream-start
Date: Tue, 29 Apr 2025 18:39:17 +0200
Message-ID: <20250429161115.747341158@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ebf185efadb71bd5344877be683895b6b18d7edf ]

The driver might skip the ov08x40_identify_module() on probe() based on
the acpi_dev_state_d0() check done in probe().

If the ov08x40_identify_module() call is skipped on probe() it should
be done on the first stream start. Add the missing call.

Note ov08x40_identify_module() will only do something on its first call,
subsequent calls are no-ops.

Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Fixes: b1a42fde6e07 ("media: ov08x40: Avoid sensor probing in D0 state")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov08x40.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov08x40.c b/drivers/media/i2c/ov08x40.c
index 8b9c70dd70b88..1fe8e9b584f80 100644
--- a/drivers/media/i2c/ov08x40.c
+++ b/drivers/media/i2c/ov08x40.c
@@ -1908,6 +1908,10 @@ static int ov08x40_set_stream(struct v4l2_subdev *sd, int enable)
 		if (ret < 0)
 			goto err_unlock;
 
+		ret = ov08x40_identify_module(ov08x);
+		if (ret)
+			goto err_rpm_put;
+
 		/*
 		 * Apply default & customized values
 		 * and then start streaming.
-- 
2.39.5



