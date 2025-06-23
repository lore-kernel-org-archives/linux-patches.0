Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44C51A00F0;
	Mon, 23 Jun 2025 21:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715389; cv=none; b=P45KoN+oWVO9DXTcD+r4RYj65+TIS8cdaUWyhJSoprFuYEAdEJZdSuyMzrTOH2/Bba35uN4IcFDgaSgk+w2hFeBLsw26NbkplkK8QNl40eCexiRhlSSxaSVPxtg9+KNvdQ0S7ZUsU5bpxO8hEimw9aAvus9YO38Rp+jfeLegJUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715389; c=relaxed/simple;
	bh=5PKhaEgRy51tNomVjb+VG0zNBFKQ/fgzLaWicPTxMaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9V03eZLr6kdFsZxFU68+W1wLp5utaFqediOnTfIygocY992/kEZ1s78aI13R0oeMnPzxkGbk1Sru68+2I0ihi4ir4LuqWnxAmnq9Me26NFhGPNgM9k3Aw3qSYgfCDv3PEzNp5Q2u+4MPl+t03c5TlkAbCRwLk/uqxl8sSXNVB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXczB4qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXczB4qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C90BC4CEEA;
	Mon, 23 Jun 2025 21:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715388;
	bh=5PKhaEgRy51tNomVjb+VG0zNBFKQ/fgzLaWicPTxMaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXczB4qvKnjgSAc1U0veO8wGEE62dWAwihQ7QmZJtbGUdwSuLS6vwI/dstuz1Ah/O
	 kZfjizBASWJTn+VETuJsY83WkPzaNxO9623F9skCXH8fgfIWnrWd3r4CbNe03x++97
	 bKzvEAyskezg+/VkA7S3w52orwfjAmo87h8htBIE=
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
Subject: [PATCH 6.15 455/592] firmware: cs_dsp: Fix OOB memory read access in KUnit test (wmfw info)
Date: Mon, 23 Jun 2025 15:06:53 +0200
Message-ID: <20250623130711.252960322@linuxfoundation.org>
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

commit d979b783d61f7f1f95664031b71a33afc74627b2 upstream.

KASAN reported out of bounds access - cs_dsp_mock_wmfw_add_info(),
because the source string length was rounded up to the allocation size.

Cc: Simon Trimmer <simont@opensource.cirrus.com>
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Cc: patches@opensource.cirrus.com
Cc: stable@vger.kernel.org
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250523155814.1256762-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/cirrus/test/cs_dsp_mock_wmfw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/firmware/cirrus/test/cs_dsp_mock_wmfw.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_mock_wmfw.c
@@ -133,10 +133,11 @@ void cs_dsp_mock_wmfw_add_info(struct cs
 
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
 


