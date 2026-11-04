Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831559;
	b=MyDlo2tdkMnoGNNVzZOjFB26yOnQqouUiL5jy6Z7a0fxGt41P2l7E7HiBOz6vI/1cJSp
	 Gx/46RK/csmzR6XZhOfuqHOrMw962qAwdJHt/bk7A7EbhiWWIfNHbv57vSrl9q4GuRqrc
	 RpH5j7anjnl0Hxwg9NGc3L86R4qYYbKl1JN93dlrNnbT3hivJyEzOCJaNUTsNbWtuJ1dp
	 S1rO2xUdaEmSjUpUz8vlCDpy1hC+PREilrydsIiCXRjQM+fppu5HAMqF8CxtgReETihFg
	 HqRqsIV1k5EYCaC3HdiU+tqErzfaHWa7c/eKOEPZB+D3BFIy3mwBzoitOaU3wlKkqJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JAupijwPz8vkd9IllPJ7zfG92gv5r8EWUAn7/lwVWSk=;
	b=TqHYkty7+1AAyoAUfTKXbXP9gta/XAV1JF4ddN5gnrXdYgg8oRGnftaqfJ2HFm9TEYZh
	 beiQWwV1P3Y0BcvqvXxdMTtLpIPPuGMirTIT4o0es9ypign36pAIYAnmMnhoPvfDqS8AK
	 Ml/19haPlCdSpQ91MT6YlLneeJEl5yhRNRZ68r4Aft0PQfGNMXlz5scuFm7Y1NvWD1wiw
	 h0UL1Q8VIDjnheJotwcmiX03mFpqZLrLMU/H5Zx5fZp9pyNFccbCUdGfuWTt1+77in+Q0
	 UG34MeRDrmYUokYwBOfv/aILYY3aYzWsqcdGSNNZQGQ9v9HTfekRLGU8w9LIjBNLuHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkpwNYhW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C893C606A844;
	Wed,  4 Nov 2026 22:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkpwNYhW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A281F00A02;
	Wed,  4 Nov 2026 22:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831558;
	bh=JAupijwPz8vkd9IllPJ7zfG92gv5r8EWUAn7/lwVWSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkpwNYhW/DRNs+UdV5s8Im5twqt+JGw2olLnNj/0owTu1SXCgroEPwOniP133SnaI
	 v+zMVVTyAlE7RIbRFNeA2EDh6KcXmER2pRyMXqadUDr6dZ2MwTGWoh2AR3CpMgoFRg
	 HJzXjnLB7WiFUaLWvDyRGIy+5mQ9igD4xdGGiVMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0775/1005] xfs: compute the correct fdblocks/frextents for repair when theyre negative
Date: Wed,  4 Nov 2026 16:08:28 -0500
Message-ID: <20261104211105.088558712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f98d007017acf0eaec2e116ff9c0ece735f61bb3 upstream.

LOLLM observed that if either fdblocks or frextents are negative, we'll
set the CORRUPT flag and exit immediately.  This doesn't work for a
repair because we still have to walk the filesystem metadata to compute
the correct summary counters so that we can install the new values.
Currently we just write zeroes into the summary counters, which isn't
right.

Cc: stable@vger.kernel.org # v6.9
Fixes: 4ed080cd7cb077 ("xfs: repair summary counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -541,7 +541,10 @@ xchk_fscounters(
 			return -EDEADLOCK;
 
 		xchk_set_corrupt(sc);
-		return 0;
+
+		/* Need to compute all the fields in fsc for a repair */
+		if (!xchk_could_repair(sc))
+			return 0;
 	}
 
 	/* See if icount is obviously wrong. */


