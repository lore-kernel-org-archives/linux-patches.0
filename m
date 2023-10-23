Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC2E12B7A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGPiT05W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE70C433C7;
	Mon, 23 Oct 2023 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059516;
	bh=ROk9UdBFCPd0RZ5m8PhSgAOjoSpsZcsWwohdFPwwqOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGPiT05WfdNKIrvuNdwk/2jKuvZ7DsZA4+Hj5e8tFdxN5bRUkcEXcW7/cogpJnUWJ
	 a+DnjDKWHMF5tUFkyvnG3iakoXuAWKV1l6uvjceSfIKnSPlniWfMdIrlnfOM3S4ynO
	 qEO0j4XEOJ3FvOLWACfqU9n8FqUYIuvK3K7wGOvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.5 176/241] mmc: core: Capture correct oemid-bits for eMMC cards
Date: Mon, 23 Oct 2023 12:56:02 +0200
Message-ID: <20231023104838.176168312@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@wdc.com>

commit 84ee19bffc9306128cd0f1c650e89767079efeff upstream.

The OEMID is an 8-bit binary number rather than 16-bit as the current code
parses for. The OEMID occupies bits [111:104] in the CID register, see the
eMMC spec JESD84-B51 paragraph 7.2.3. It seems that the 16-bit comes from
the legacy MMC specs (v3.31 and before).

Let's fix the parsing by simply move to use 8-bit instead of 16-bit. This
means we ignore the impact on some of those old MMC cards that may be out
there, but on the other hand this shouldn't be a problem as the OEMID seems
not be an important feature for these cards.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230927071500.1791882-1-avri.altman@wdc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -104,7 +104,7 @@ static int mmc_decode_cid(struct mmc_car
 	case 3: /* MMC v3.1 - v3.3 */
 	case 4: /* MMC v4 */
 		card->cid.manfid	= UNSTUFF_BITS(resp, 120, 8);
-		card->cid.oemid		= UNSTUFF_BITS(resp, 104, 16);
+		card->cid.oemid		= UNSTUFF_BITS(resp, 104, 8);
 		card->cid.prod_name[0]	= UNSTUFF_BITS(resp, 96, 8);
 		card->cid.prod_name[1]	= UNSTUFF_BITS(resp, 88, 8);
 		card->cid.prod_name[2]	= UNSTUFF_BITS(resp, 80, 8);


