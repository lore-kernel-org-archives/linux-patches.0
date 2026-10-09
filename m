Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A35A4582D3;
	Fri,  9 Oct 2026 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556859; cv=none; b=owNx9aLDK1Onin769z8D3xIvlKcO8MAbIONh7taa5AK/UMkylvaV9b0m4VhLbUsQLQvur6ZG17JlX9qdNWKX3kukP2OtLh+WOBLbvjZzbIgWWr8pAJJj52nmNhdu0AMxVrucNQSoyUiybaGScE7iy02BLmLrl8uWcjsmGR3EROc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556859; c=relaxed/simple;
	bh=EAdDnSP1JIVuTWmbYNaapvEQ8k0rmVIpp+8/82zDhBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjIMuFhyVoK2n0T2F9/Wbv41TSxQMCh7EWmGdD87QuBC2jocjA4bY8xqNadqU2WwT0VTvI5mQCwlPqLqTQgLe3O+nYFLcp3k8npzMSFW7z5+6PUcQdNTjzhIcmWhYXcL1P2LhG5MIW+RWQBJJOuOqsheP5KSmN39gjS/d4Pe4K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6FLH6Mc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6FLH6Mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4FD1F000FF;
	Fri,  9 Oct 2026 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556857;
	bh=1lnnq7pZuiBE8bzKIf2mJOAwuAJlebQ+ixTL3UgXNNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6FLH6McnFf7Cq9nkItbCQCupTnPjHl0eJJoQL96OlP0wcyqJR56t1eXciSqHJvSd
	 Wf5JX7hDrwDzwyP4fd2YhP69L4I3IjrY+bKx6B+hf/0d+Bbm+2v+LfAK1GeZ08mZIG
	 bQZ2MqHVI1mYnd8TmsotA6WCY7e0yCqJgTx+RMEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 304/403] iio: adc: ade9000: fix overlapping scan_index for current and voltage channels
Date: Fri,  9 Oct 2026 16:11:05 +0200
Message-ID: <20261009140959.324752427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit d01f63f673e18f3a99ce8d6fbf1a5f58b70990f7 upstream.

Current channels used scan_index "num" and voltage "num + 1", so with
phases 0, 1 and 2 the indices overlapped and no longer matched the
IA=0, VA=1, IB=2, VB=3, IC=4, VC=5 layout expected by
ade9000_waveform_buffer_config(). Phase B and C buffers were configured
incorrectly.

Use "num * 2" for current and "num * 2 + 1" for voltage to get the
non-overlapping 0/1, 2/3, 4/5 layout.

Fixes: 81de7b4619fc ("iio: adc: add ade9000 support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ade9000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ade9000.c
+++ b/drivers/iio/adc/ade9000.c
@@ -448,7 +448,7 @@ static const struct iio_chan_spec_ext_in
 			      BIT(IIO_CHAN_INFO_CALIBSCALE),		\
 	.event_spec = ade9000_current_events,				\
 	.num_event_specs = ARRAY_SIZE(ade9000_current_events),		\
-	.scan_index = num,						\
+	.scan_index = num * 2,						\
 	.indexed = 1,							\
 	.scan_type = {							\
 		.sign = 's',						\
@@ -468,7 +468,7 @@ static const struct iio_chan_spec_ext_in
 			      BIT(IIO_CHAN_INFO_FREQUENCY),		\
 	.event_spec = ade9000_voltage_events,				\
 	.num_event_specs = ARRAY_SIZE(ade9000_voltage_events),		\
-	.scan_index = num + 1,	/* interleave with current channels */	\
+	.scan_index = num * 2 + 1, /* interleave with current channels */	\
 	.indexed = 1,							\
 	.scan_type = {							\
 		.sign = 's',						\


