Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9583B8407;
	Tue, 21 Jul 2026 20:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667303; cv=none; b=qH7VYwECEzu1xLaP4wvG5ZUm3OrVrr71qGocubsGy7j30Rj+nYQOFHHK4hwrMP2pmJVVHE93ggacTArvfaZNaJFZyqGCloITUgXDXy6jZ+UR/jQ/evAyK2dT75U+Ol+Zeq17FUwmROqRv9Zh89uHp+rUdosmZK7ssuHLo7lgpXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667303; c=relaxed/simple;
	bh=T9v2sElAHlc51J0tINVWb1FVuGQhCDekW6O91pcXpeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWOX2xOv1MAHEhzXfrF7XfmkjTwEL4PzAMa8vO0MD7DVWt8zQMgSgH25SaK1y6lJbykY7bdiRvyetJYHArAufzRDpXt0X9LdUJ2uKDGcP7bg58dNd+o8Z4crUUte6I494TqHKZ8S/W/krrZC59cw8QRw6cj5+2W64cfta84MwE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzAtdZTQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzAtdZTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73911F000E9;
	Tue, 21 Jul 2026 20:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667302;
	bh=W/+u11mSe3U2usTmRvjGnesPe5M1fL22kL14BalxolQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzAtdZTQVnP5CKlJu7w7ADMAdjcfE7rz6/5eyLcwCsu3b0MoH62UeRwKOE7/HK+Ik
	 XdfiwgDSPYkHAYgSOoF1iCakjcjf/5Kq31BhH3+fp522kShGWEL1CJF2dkFbt0S7nr
	 WJ0H3TMRY+IqPexTAmD85C5Ewkvs5DWSFxdPJuCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.6 1008/1266] fpga: dfl: add bounds check in dfh_get_param_size()
Date: Tue, 21 Jul 2026 17:24:05 +0200
Message-ID: <20260721152504.383489121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Sebastian Alba Vives <sebasjosue84@gmail.com>

commit 9e8bc49f91f3f81d957c4f1c1f09fe94e2f88f6a upstream.

dfh_get_param_size() can return a parameter size larger than the feature
region because the loop bounds check is evaluated before incrementing
size. If the EOP (End of Parameters) bit is set in the same iteration,
the inflated size is returned without re-validation against max.

This can cause create_feature_instance() to call memcpy_fromio() with a
size exceeding the ioremap'd region when a malicious FPGA device provides
crafted DFHv1 parameter headers.

Add a bounds check after the size increment to ensure the accumulated
size never exceeds the feature boundary.

Fixes: 4747ab89b4a6 ("fpga: dfl: add basic support for DFHv1")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Alba Vives <sebasjosue84@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260518190742.61426-2-sebasjosue84@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/dfl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -1117,6 +1117,8 @@ static int dfh_get_param_size(void __iom
 			return -EINVAL;
 
 		size += next * sizeof(u64);
+		if (size > max)
+			return -EINVAL;
 
 		if (FIELD_GET(DFHv1_PARAM_HDR_NEXT_EOP, v))
 			return size;


