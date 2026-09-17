Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0455B3A1686;
	Thu, 17 Sep 2026 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661210; cv=none; b=r47yOakusOGMay4NGrpEVzfWYitVYBrjJs8ncYxcLi7P0Hk8jtSDRW3Hxas7l63Uv1u5NQNo2oiJ10PPQp3r74YcpQWEGPB7eqFYOltwil5xK0UtgahIuB/5sCejJMRty+hhfi2hwh4iXXipXIxQ176cJYJYKLFpBN9J/85Jchc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661210; c=relaxed/simple;
	bh=fDRPIv4+BcZfX3/1u0EgfIKpBlijAD0JQAo51E1qA+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diPcBR3GHPDif7HVel85t10bgVfJGUXgDi8THcnMHJZoc6lfs67NXGePJiOlSGlCXXWDYcbmyC2tmkrDwZjZi6oDTRLpY0Vj3HA+w3lerSHCLoGGu32muiFmxuAa+42rxpvch6193MfAGVd6t7RDIF93bTY5qPqMD6rOgWqNFzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUzqXqw1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUzqXqw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544451F00898;
	Thu, 17 Sep 2026 16:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661208;
	bh=lExZN2ehkCe3NfsKbfFcK1KKTb9MgHS+3KTSoBRH1dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUzqXqw1a7YCO6xZaDYVj+DL2aACr3VcNjXwxgZe1GOcl+/QLW5h6UHzcgRkq6Dj8
	 hndsUuZ36qnlcOMG2edduyF6Mexhbz7Y69j8iT0aJyBHDlAaivViav1KWkKEkkgx36
	 DzgxB5rmOzdZ8Jcuxv914RykzlxccF8rCmWm5OxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0080/1250] media: qcom: camss: avoid format string warning
Date: Thu, 17 Sep 2026 15:57:55 +0100
Message-ID: <20260917151554.137442222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2de97f58f9ae4..74c77969db7ef 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -558,12 +558,16 @@ static int csiphy_init_formats(struct v4l2_subdev *sd,
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



