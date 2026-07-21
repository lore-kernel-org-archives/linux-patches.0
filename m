Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9137BE64;
	Tue, 21 Jul 2026 22:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673127; cv=none; b=TVhz6ufB3RpoF57lZaTfb6FevIa7XT6rudhrW99Hkm6G0qU1gQkSuEzYXicTvmcrmU8muHlS6cqQIHo+0vdEE0JWD9hpbJxy+gyhL2n6mojGPTqRHLIF6gNmzGKOsM9hNMGQPIMbjOBY9plm9Q2dKlyxmDD35C6hqMJzFzCBGXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673127; c=relaxed/simple;
	bh=ashIrj0wqvDZBjRd7bsTUOUk8PqegEcUSabcIPvfDNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jk1FCrELYBerAP17w5Q6mSUW2wjABPE7OBj61XXW+iOKZWdVEQYtm73YoIjbEqD8FGZ0+UcoWdxOmJkJ9QO3lINAssg2+ppR7iJXtxsCiWSP62zQZNZ8eP0LNDc1K7iWghbgWZQMkmmnDt2Rxs+gDs8tBsyIQqD3vFJqUBA2vzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVqWQC6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVqWQC6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284BF1F000E9;
	Tue, 21 Jul 2026 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673126;
	bh=24iRHEpiDLo32Qa8p1AcQQDGJbtzFG8sD4jZy1xSOro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVqWQC6ICHxBLvEjrxu8kPlK4b5uxF73K+E30p07reKC9mrGhFHm9AgkbW2RD40TY
	 FKkejW+3Ep3/Qtk389D5l7p2NcL3hHhD7sNlf9uEqoFPVjCDopiIwFRyqJnledVKt7
	 Ol+127b1vC40OgeyTHqriSA1UgUduvLl0pAJ6YTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 046/699] iio: light: gp2ap002: fix runtime PM leak on read error
Date: Tue, 21 Jul 2026 17:16:45 +0200
Message-ID: <20260721152356.749486734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

commit 38b72267b7e22768a1f26d9935de4e1752a1dc85 upstream.

gp2ap002_read_raw() calls pm_runtime_get_sync() before reading the
lux value, but if gp2ap002_get_lux() fails, it returns directly. This
skips the pm_runtime_put_autosuspend() call at the "out" label,
permanently leaking a runtime PM reference and preventing the device
from autosuspending.

Replace the direct return with a "goto out" to ensure the reference
is properly dropped on the error path.

Fixes: f6dbf83c17cb ("iio: light: gp2ap002: Take runtime PM reference on light read")
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/gp2ap002.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -258,7 +258,7 @@ static int gp2ap002_read_raw(struct iio_
 		case IIO_LIGHT:
 			ret = gp2ap002_get_lux(gp2ap002);
 			if (ret < 0)
-				return ret;
+				goto out;
 			*val = ret;
 			ret = IIO_VAL_INT;
 			goto out;


