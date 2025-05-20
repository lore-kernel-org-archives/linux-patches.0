Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC58241103;
	Tue, 20 May 2025 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749358; cv=none; b=N3v/Psi9pXBEMkoqT16NObFlWNhyCZB6jA1roZtmPZMzKpsWJezgWONysPzxxOHc/2b0jB/5KCY6Hkti9QZI/ghECMG2u8YHwLNVC2FPCWRM+R0Cz2W9fMgRR5MJPW8yAIKq+R7tu5Lr+eA/Sxc7i4Sj7/dbBUKMcPREXayz1rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749358; c=relaxed/simple;
	bh=rQixnpYafH5pVJi3raHCjPvw2oFOdrX3Ho2A8/RWWhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u/hzcDb40wx24TFs/ePDW0s2oQA0WieTaGoyXXTc3vIsyAa6vERNHxgkWI5IbCSRMRHBohD7YbHAJIJgxGVZWJC4XU/vlxa2ypD1kPTHTBp21rPZl0LVscQ+DC/Kb8SHRSlkqUn5TehB9K7/cPdfUXK2POWAAR7thSMsHEWEUIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3yxHjpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3yxHjpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A32AC4CEE9;
	Tue, 20 May 2025 13:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749358;
	bh=rQixnpYafH5pVJi3raHCjPvw2oFOdrX3Ho2A8/RWWhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3yxHjpveYLT/tLYiaJ3TCtg244g/+sv8Rn8sL2A9z3E4++nachQI+ddDs2aaRQfp
	 F8cgeIRtZbIYGDtQYWxzFXeUKarYttburVVJpD/Kdc9aAsK3i8vjUbhicZxnknf1aX
	 BJEHnfJHqvcPYqJ9Qh7/MuWvAV0BdbsmJKmZhiN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/97] iio: adc: ad7768-1: Fix insufficient alignment of timestamp.
Date: Tue, 20 May 2025 15:49:44 +0200
Message-ID: <20250520125801.422517306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit ffbc26bc91c1f1eb3dcf5d8776e74cbae21ee13a ]

On architectures where an s64 is not 64-bit aligned, this may result
insufficient alignment of the timestamp and the structure being too small.
Use aligned_s64 to force the alignment.

Fixes: a1caeebab07e ("iio: adc: ad7768-1: Fix too small buffer passed to iio_push_to_buffers_with_timestamp()") # aligned_s64 newer
Reported-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-3-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 74b0c85944bd6..967f06cd3f94e 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -169,7 +169,7 @@ struct ad7768_state {
 	union {
 		struct {
 			__be32 chan;
-			s64 timestamp;
+			aligned_s64 timestamp;
 		} scan;
 		__be32 d32;
 		u8 d8[2];
-- 
2.39.5



