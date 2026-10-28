Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216260;
	b=P1SjUqn+/P0QComLYRSYy3s3L7i9qn1Sea5ybxch5vZhdGXtggGkoCt0RFcQa/zvNSuH
	 +LOSb/iE2aWMRuoZoyq9wSUV+8oJ6PiRq7/tUubE2CDtEU1lrtphKflDjpGu9dbP1fzxl
	 MlpIRjo+4LvSXTkiWKPcykue5WMTLxEay23GfPS7ah7UYxvad4F3ot5WA7bbQRhSpCiWC
	 sY6XNZ7BKAOGqCdBu5M0BTpGyr6eFCW4EIg01otKIay3DQaxch/B9Xm3e4oUjMUodS9EN
	 KOonSxY+Ma5/jvm0DrH+tJO5aCrrbwMO9hpaMe0Ph5Ivx1ITrXOEJvJ/SB9PH6D8EWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r+ayuslOpNMDeQ9gWFcOHlUPWFbhUCn+m+cn9UIX6kQ=;
	b=YdYIk4Re1X42TAeLbYbW9ugoJup6sJYSmJzQl+ukaUREsFQhqI7q1Czp1Ba4P48g9X0N
	 RhVZzTLQJowwtxJEkkKwN7mMyt54XqqIf9AIfvRWmlvogPkF0b43BYJUeUQPAW8/Fq47X
	 KEmSIZBuTP5DnPrEQt7kTmBbRaWJF9avNd43qOJSe2MK4+dA7MB7zu1Oy7hWvkBffLpih
	 jBGJv4Be+fR1uHa3OypAGMsN3H2frON754G+6hbDWfRpfPw/D25ezTJwO4WdzX7xS7ztR
	 tJactw9Hmcrqap0bRBgBLhmY952ca/QnlS1SLpTb99WjXZ7SB1Ys/qMuj1HY0jFRZcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DbMJoEX/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB524606A31D;
	Wed, 28 Oct 2026 19:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbMJoEX/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127161F01825;
	Wed, 28 Oct 2026 19:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216259;
	bh=r+ayuslOpNMDeQ9gWFcOHlUPWFbhUCn+m+cn9UIX6kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbMJoEX/NCyxi7Bw8LYSIgkwG1uJ/2Rued4UJdo67LD37teCB6ROGGob8NUM/thvP
	 RzK8aq/o+Fxyp/24WksWL5/pbEWPshDtKQiDKScGkTR92IYQPfjDwTRPm6rJ0gughw
	 iFBtd+s+5/HOH4CE+DWROsTMLOJBiA21qhLM0F6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1495/1887] iio: light: ltrf216a: fix runtime PM reference leak in error path
Date: Wed, 28 Oct 2026 17:59:51 +0100
Message-ID: <20261028170533.477997993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidhu Sarwal <vidhu.linux@gmail.com>

[ Upstream commit c132aef0e757a39036b1d40faf0569f2e343b13e ]

ltrf216a_get_lux() acquires a runtime PM reference by calling
ltrf216a_set_power_state(data, true). However, if
ltrf216a_read_data() fails, the function returns immediately without
dropping the reference.

This leaves the runtime PM usage count unbalanced, preventing the device
from autosuspending after a failed read.

Fix this by releasing the runtime PM reference before returning from the
error path.

Fixes: 83f0bcd40d5c ("iio: light: Add support for ltrf216a sensor")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltrf216a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/light/ltrf216a.c b/drivers/iio/light/ltrf216a.c
index 45011be4207b3..85d8f5329bcee 100644
--- a/drivers/iio/light/ltrf216a.c
+++ b/drivers/iio/light/ltrf216a.c
@@ -241,11 +241,10 @@ static int ltrf216a_get_lux(struct ltrf216a_data *data)
 		return ret;
 
 	greendata = ltrf216a_read_data(data, LTRF216A_ALS_DATA_0);
+	ltrf216a_set_power_state(data, false);
 	if (greendata < 0)
 		return greendata;
 
-	ltrf216a_set_power_state(data, false);
-
 	lux = greendata * 45 * LTRF216A_WIN_FAC;
 
 	return lux;
-- 
2.53.0



