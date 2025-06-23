Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3BB1A00F0;
	Mon, 23 Jun 2025 21:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715371; cv=none; b=ZsLuRHor5rBI0+lTKcKMQ/yLqz7yd66UW0W3e26hIUKqPEqTVGYMByB5mwRAvmUrkwuyKGdKr+lYISGtImHBgHye1J2FY3w6EhlFwC/cmazIWvirYIOLxeYd/DucIBarFu1dktjkrNfuAYMD7X4l5Cb/8+ENu8dniQeFf3Aiato=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715371; c=relaxed/simple;
	bh=AeTwDqoMDujZCM9P+O9HLW2S1dA0Tw0fC7FKNiKIQqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn9es/8601Ow6/sgz8dlip2xgB6GjCs5uiXtxtpSPcQNDVHui/t+uPGWOP1ZNBJo3Srm6fG46c7QI5fVhZ7j8mC0yTONQ/tvK08j63mXYUiu19/SvnFwG+Jpb8QVqCDnqjaysGtoVWnjdlMbkH8D0pOfnbTrrAZUn/w/2Di5w+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Puy3jobW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Puy3jobW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430A1C4CEEA;
	Mon, 23 Jun 2025 21:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715371;
	bh=AeTwDqoMDujZCM9P+O9HLW2S1dA0Tw0fC7FKNiKIQqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Puy3jobW3zbG3sPe5KUDPEdjsIugpLl5ej2eUuAOUgZ0PYQ1O65Jz5IBoul6MhOum
	 XVDKSE3MB9mZ5M9UbjtabcqEyeoMf3lo82Kc63SDynXvncUfCLApPL7btiNt8jtHTd
	 9NW9wHukHxJikWa+Ds/iQwj7PoE7mr8CJAlc/yyI=
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
Subject: [PATCH 6.15 454/592] firmware: cs_dsp: Fix OOB memory read access in KUnit test (ctl cache)
Date: Mon, 23 Jun 2025 15:06:52 +0200
Message-ID: <20250623130711.228112239@linuxfoundation.org>
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

commit f4ba2ea57da51d616b689c4b8826c517ff5a8523 upstream.

KASAN reported out of bounds access - cs_dsp_ctl_cache_init_multiple_offsets().
The code uses mock_coeff_template.length_bytes (4 bytes) for register value
allocations. But later, this length is set to 8 bytes which causes
test code failures.

As fix, just remove the lenght override, keeping the original value 4
for all operations.

Cc: Simon Trimmer <simont@opensource.cirrus.com>
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Cc: patches@opensource.cirrus.com
Cc: stable@vger.kernel.org
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250523154151.1252585-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/cirrus/test/cs_dsp_test_control_cache.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/firmware/cirrus/test/cs_dsp_test_control_cache.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_control_cache.c
@@ -776,7 +776,6 @@ static void cs_dsp_ctl_cache_init_multip
 					      "dummyalg", NULL);
 
 	/* Create controls identical except for offset */
-	def.length_bytes = 8;
 	def.offset_dsp_words = 0;
 	def.shortname = "CtlA";
 	cs_dsp_mock_wmfw_add_coeff_desc(local->wmfw_builder, &def);


