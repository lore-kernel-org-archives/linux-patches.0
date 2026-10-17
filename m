Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46EA3B47F5;
	Sat, 17 Oct 2026 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260292; cv=none; b=uVSD5JcSNYmue1ELQx4SrfdTss43WfTeO/6303Iyg3F+9gfuXJ58ZJ3TWBcDDVMGLStxHJ36zfa6NZnnYDTUnQGNHGqVG0Ho5pLGOMEoZR/r4zb/l5mCihZ2+RuVxU2cY5pARf/iZ3+4aC55UbIN3rBewdOcGsd3a3qbIVs2Tv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260292; c=relaxed/simple;
	bh=sVhy/LfrCxFLRv0LJrEDyiknokJTmM558RjPf2CvY94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJ8iYPAoptw7bSNcIU3TtoWsp4nH4REzzsTjnCT8kgxKirUaY3HxQj5lMvSFbBxNyy9RupHpgdCDZnsa/EI8IpNDGvbv29fNTOJA16kKCp5wBzyINqdHbeozy82zIVp+/9PN6ICmQFBRlpQkeGo2DUwNjkpl8EJCpSQiwEV7x+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axhRaqsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axhRaqsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D750E1F000C4;
	Sat, 17 Oct 2026 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260290;
	bh=6BOsPwd1ypID44XtHoQQoUOSIrivUWqV9OMItmLHh04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axhRaqslXFRmjvbvXMnZMwv7m3trJv+g779S/f+htTW2yeQk7Ic7Z86CYzvAH/i//
	 kSWcjCaLIPUb8jf338Zn/UyWBIHZwKrMLojNP0IrY8QBz8QKMObIDh9l406I612RjG
	 GZB6ZIT9GtJhpazgkz/rFYeXN63CxYbFp2YMbBJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manos Pitsidianakis <manos@pitsidianak.is>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1494/1674] hwrng: core - fix rng list on registration error
Date: Sat, 17 Oct 2026 18:02:46 +0200
Message-ID: <20261017160509.491261062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manos Pitsidianakis <manos@pitsidianak.is>

[ Upstream commit 3a5834db2b1ce25649f330e78efe1ccde78967fd ]

hwrng_register(rng) does the following:

1. Checks if rng has name and read methods set
2. Checks if the name already exists
3. Adds rng to global rng_list
4. May try to set rng to current_rng

If step 4 fails, it returns an error. However, it does not remove the
rng from rng_list, causing a dangling reference which can result in
use-after-free if the caller frees rng, since registration failed.

Add a list_del_init() cleanup step.

Fixes: 2bbb6983887f ("hwrng: use rng source with best quality")
Signed-off-by: Manos Pitsidianakis <manos@pitsidianak.is>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a182fe794f985..6863121e16b01 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -574,7 +574,7 @@ int hwrng_register(struct hwrng *rng)
 		 */
 		err = set_current_rng(rng);
 		if (err)
-			goto out_unlock;
+			goto out_list_del;
 		/* to use current_rng in add_early_randomness() we need
 		 * to take a ref
 		 */
@@ -595,6 +595,8 @@ int hwrng_register(struct hwrng *rng)
 	if (is_new_current)
 		put_rng(rng);
 	return 0;
+out_list_del:
+	list_del_init(&rng->list);
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
-- 
2.53.0



