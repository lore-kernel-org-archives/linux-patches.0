Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC772572673;
	Wed,  9 Sep 2026 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963832; cv=none; b=apnDNXuf4gMyp3G3K1r2iNBlOs8a0agc5Z+CGn7bNlcP3nileXKfopRpV0R/G+fftfDrt4GvxfEU/KIuB6ZkkrqQNyIpEYYnOgdRERdNP5jQCEjQYXFE25bLXGrug1fR4fMPxDT2WA+4srbaqY9Nn9ld63/qeDO+7MWFivHxZfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963832; c=relaxed/simple;
	bh=znK+2AgZSAM5RDHfFIpKQGiy+C6ysjneO85qYL8iZoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tx8+xwVLYDx8k4GodlNe2ltOZwE/w7aI7Lw/4CnTuFqEr1WNWCnlcJ2/d23IK4MTD194JPXwCIeuY4VomBgy4pu2HyIRPgwtDfP3DpX/n6U5UvdmJGBZjr8mz4lZwLO/8CQEsBIN2a2vT/9ClgHr0kdVmAtKzJ78tYHgjPt3moY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKggwscT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKggwscT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A661F00A3A;
	Wed,  9 Sep 2026 14:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963831;
	bh=wnNIx78CpRzN8S7Yux35vU8t6WORCJoVVgSVnWLGVus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKggwscTpsH4ACuLX9Cs0kZO3+oET6nJV36yU0EsrwW4WP/l+F7Nat5Ft/pWVvwws
	 fkPibXCKQDmBtAYtD6PGvTZoJY7Hvoem8mG9geaZYj4/JH/S6zi6ZpQAezrCX8PSSR
	 o2M6Fdl+Wp+VC5cT5eFdKRwZ1UUL5MJXEWWfZIu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 212/583] iio: dac: ad3552r-hs: fix scnprintf() buffer bound in data source show
Date: Wed,  9 Sep 2026 15:38:17 +0200
Message-ID: <20260909134245.488168127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Babanpreet Singh <bbnpreetsingh@gmail.com>

commit f2c5c76306fadb834dd5ea76cab0b7cd447e6035 upstream.

ad3552r_hs_show_data_source_avail() formats the available data source
names into a 128-byte stack buffer, but bounds each scnprintf() with
PAGE_SIZE instead of the buffer size, so the bound does not protect
the destination at all.

This cannot overflow today - dbgfs_attr_source[] has two entries,
"normal" and "ramp-16bit", 18 bytes formatted - but the bound stops
protecting the stack the day the table grows. Use sizeof(buf) so the
bound matches the destination.

Found by smatch:

  drivers/iio/dac/ad3552r-hs.c:593 ad3552r_hs_show_data_source_avail()
  error: scnprintf() 'buf[len]' too small (128 vs 4096)

Fixes: b1c5d68ea66e ("iio: dac: ad3552r-hs: add support for internal ramp")
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Babanpreet Singh <bbnpreetsingh@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad3552r-hs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad3552r-hs.c
+++ b/drivers/iio/dac/ad3552r-hs.c
@@ -591,7 +591,7 @@ static ssize_t ad3552r_hs_show_data_sour
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dbgfs_attr_source); i++) {
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s ",
+		len += scnprintf(buf + len, sizeof(buf) - len, "%s ",
 				 dbgfs_attr_source[i]);
 	}
 	buf[len - 1] = '\n';


