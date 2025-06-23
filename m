Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D94924EA85;
	Mon, 23 Jun 2025 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684292; cv=none; b=HHVzhFubAmWbwpEtAcgHLZuJZnrlZpuh66w/B94XG8e6QUVfrDOokqk3gX9++OgR22mVBpjoyk0xD7S+uvp/aJ1Jjmxrbvwmpovb/7kJj4In44A59LDBt0QdO1+9YveY4B95DBt1cbYh4wWZgrfkMq6rVYPd2ODUCajVOo+hPXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684292; c=relaxed/simple;
	bh=MxpWJp0FIFb6H01qH2PdPCXFEjIVQcyWVpDo5AUnYhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBRjwW+8hYLxFYu9npqC2JtQEIi+NNAEe/ZwOfZ15S8FRS3zep1kiU/Ku7xGQg26xi95x2NfeS5nvGArU303oADxBqdP7ff8qat8Ak/DEBUUK3vV1MMVecRqCxAEG2gKfhJTjheZIgjeXTSZ27aqKqQnKj6f75L7eInMg9NRl7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zr97MlXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zr97MlXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D90C4CEEA;
	Mon, 23 Jun 2025 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684292;
	bh=MxpWJp0FIFb6H01qH2PdPCXFEjIVQcyWVpDo5AUnYhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zr97MlXOJd1CgJ0nHqQOp2iJBHwFakCrn4LTdbVSxlyIkSeTfHP4q9EjbFeAsOmJd
	 OyYi5ZRh3gQ8AhNodKXgmF5/XA9gSbLHmyA8cCXwZPmh7XtFKhGw/x4+osrnM4j9cH
	 U3AdmhF4jC36kmkr8T01KBeCK3g5pRF6EuJ8rcZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	patches@opensource.cirrus.com,
	Jaroslav Kysela <perex@perex.cz>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.15 013/592] firmware: cs_dsp: Fix OOB memory read access in KUnit test
Date: Mon, 23 Jun 2025 14:59:31 +0200
Message-ID: <20250623130700.541685721@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaroslav Kysela <perex@perex.cz>

commit fe6446215bfad11cf3b446f38b28dc7708973c25 upstream.

KASAN reported out of bounds access - cs_dsp_mock_bin_add_name_or_info(),
because the source string length was rounded up to the allocation size.

Cc: Simon Trimmer <simont@opensource.cirrus.com>
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Cc: patches@opensource.cirrus.com
Cc: stable@vger.kernel.org
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://patch.msgid.link/20250523102102.1177151-1-perex@perex.cz
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/cirrus/test/cs_dsp_mock_bin.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/firmware/cirrus/test/cs_dsp_mock_bin.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_mock_bin.c
@@ -96,10 +96,11 @@ static void cs_dsp_mock_bin_add_name_or_
 
 	if (info_len % 4) {
 		/* Create a padded string with length a multiple of 4 */
+		size_t copy_len = info_len;
 		info_len = round_up(info_len, 4);
 		tmp = kunit_kzalloc(builder->test_priv->test, info_len, GFP_KERNEL);
 		KUNIT_ASSERT_NOT_ERR_OR_NULL(builder->test_priv->test, tmp);
-		memcpy(tmp, info, info_len);
+		memcpy(tmp, info, copy_len);
 		info = tmp;
 	}
 


