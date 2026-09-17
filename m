Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8032F502D4E;
	Thu, 17 Sep 2026 17:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667335; cv=none; b=E0GzDnQDCEfojcBOcDVETREyGELgbrBylyNnHyiD58Wjh41LRowjmzXfeT5Kj2b5sSW01Su2amoRJWScdSO3whBbL7t+xBXqpgzNMhiA3o7U9DfNyoyT3YdS6gGqhiyIixTB29PS458ON/0PkDOQSR9GqtgsynpolpDvEFDPCt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667335; c=relaxed/simple;
	bh=xtzrNd4X8XswM08EmMp2qGMJtNsXR+SNpHXZuFxZSlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBWjKuHe0Hfu7e1xWMAsH+V7/6jc98wIjA7J5c8knTSSuE75gD5jqCisT7RSoi1lIyAwIwlH6OBPKLzIv6oowZAXngtgN3Z1G8CIgQWrwlV9B9ByWce8gdYLPn4Sau+FedbiYb/OGAFo40TQFztHN+W5Pk5C5EiITZ4EgDGyKfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3huKVt2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3huKVt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C798E1F000FF;
	Thu, 17 Sep 2026 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667334;
	bh=l6zEb9g4cHJbSDw/qKPdHr/TD3oUKUdkkpGE92bgvc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3huKVt2FZMJZw1kjTa9FvgB0WZVEcIAXFus1V0tmo4ZtqnnQScpnPkyC7X0zgqiZ
	 0Uww5nO+XxM/OGOeeJnskVYUaJ8H6KNXElHJUzR7Mb433Re1YC5/PESqMIpTFlBs0N
	 +RSK1yxRnR45midsdVr6qTNWP4uP573xBU00lp2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0059/1102] media: qcom: camss: avoid format string warning
Date: Thu, 17 Sep 2026 16:00:02 +0100
Message-ID: <20260917151540.935896992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 797c1cbf672f372d6a464df0dcedf476fc715969 ]

clang-22 warns about csiphy_match_clock_name() taking a variable format
string that is not checked against the 'int index' argument:

drivers/media/platform/qcom/camss/camss-csiphy.c:566:44: error: diagnostic behavior may be improved by
      adding the 'format(printf, 2, 3)' attribute to the declaration of 'csiphy_match_clock_name'
      [-Werror,-Wmissing-format-attribute]
  561 | static bool csiphy_match_clock_name(const char *clock_name, const char *format,
      | __attribute__((format(printf, 2, 3)))
  562 |                                     int index)
  563 | {
  564 |         char name[16]; /* csiphyXXX_timer\0 */
  565 |
  566 |         snprintf(name, sizeof(name), format, index);
      |                                                   ^
drivers/media/platform/qcom/camss/camss-csiphy.c:561:13: note: 'csiphy_match_clock_name' declared here
  561 | static bool csiphy_match_clock_name(const char *clock_name, const char *format,
      |             ^

Change the function to use a snprintf() style format string that allows this
to be checked at the call site.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-csiphy.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 2f7361dfd4614..7444b42cc1e23 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -545,12 +545,16 @@ static int csiphy_init_formats(struct v4l2_subdev *sd,
 	return csiphy_set_format(sd, fh ? fh->state : NULL, &format);
 }
 
-static bool csiphy_match_clock_name(const char *clock_name, const char *format,
-				    int index)
+static bool __printf(2, 3)
+csiphy_match_clock_name(const char *clock_name, const char *format, ...)
 {
 	char name[16]; /* csiphyXXX_timer\0 */
+	va_list args;
+
+	va_start(args, format);
+	vsnprintf(name, sizeof(name), format, args);
+	va_end(args);
 
-	snprintf(name, sizeof(name), format, index);
 	return !strcmp(clock_name, name);
 }
 
-- 
2.53.0



