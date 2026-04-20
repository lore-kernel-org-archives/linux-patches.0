Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B5423BD17;
	Mon, 20 Apr 2026 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700906; cv=none; b=W0EplZVd7Pb6oLaTHdZ3hvqXPetEuuMWW3FOV2oF5JhXmJ5la7q+vuu9VdBhVt7Az0Z2TUKo9Zqd4VK7pc1gwxGl/XGyCS0BfGa8gV6CgeZbsbs1reydFTWw7rhniSandLAujpJ9/U/xeqKqjv3csc4FkJqcNVMNHl4fN+fC9L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700906; c=relaxed/simple;
	bh=c9NmwBH+PIC3Y/s1dPZgHmuKfrZp34RU77pg4ydUU80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFsacIZgw+Bgrr/YjkupOLb1XmhmM1ZXGeQUongrmydtfhryL9gknKlu6bbdIT3jbhZ5Y/Em+m74CtgIXvUqVhKJdj9eoDXqWX19i7KFOJIwqnafFDrCeBsibz/W1l3VQIe9JWogTknfFtyifoxs6l+60DzJUeXxS7eMdngUySU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDLju25g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDLju25g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F7CC19425;
	Mon, 20 Apr 2026 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700905;
	bh=c9NmwBH+PIC3Y/s1dPZgHmuKfrZp34RU77pg4ydUU80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDLju25gkUIQ2eyRa5zs7KvTWeXARuC2w4BVjITfhaiN9mRAHdNOblxI3APFyAv8j
	 QwJRYudzkTKsJpPhhH/lLRoB0kc4LMZPCYFv1nJ/2z/mSkoE9URXWRpFLF2ufA/3/5
	 TNBJkJ3c6u0R9YVV6Bt8UPbCZLhEqNpeasDF2K4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/198] ASoC: SDCA: Fix overwritten var within for loop
Date: Mon, 20 Apr 2026 17:41:23 +0200
Message-ID: <20260420153939.346764206@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 23e0cbe55736de222ed975863cf06baf29bee5fe ]

mask variable should not be overwritten within the for loop or it will
skip certain bits. Change to using BIT() macro.

Fixes: b9ab3b618241 ("ASoC: SDCA: Add some initial IRQ handlers")
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260408093835.2881486-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_interrupts.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/sdca/sdca_interrupts.c b/sound/soc/sdca/sdca_interrupts.c
index f83413587da5a..4189efdfe2747 100644
--- a/sound/soc/sdca/sdca_interrupts.c
+++ b/sound/soc/sdca/sdca_interrupts.c
@@ -104,9 +104,7 @@ static irqreturn_t function_status_handler(int irq, void *data)
 
 	status = val;
 	for_each_set_bit(mask, &status, BITS_PER_BYTE) {
-		mask = 1 << mask;
-
-		switch (mask) {
+		switch (BIT(mask)) {
 		case SDCA_CTL_ENTITY_0_FUNCTION_NEEDS_INITIALIZATION:
 			//FIXME: Add init writes
 			break;
-- 
2.53.0



