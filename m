Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA22347884A;
	Sat, 12 Sep 2026 11:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213514; cv=none; b=COtvLUP+mqCCq+EgBJEW11lOyf/tnhUiTTzkCQgra0W/5rqgz8tNGgUVtotPPTDuUx1i5gnK3fdfNz2LGIt8DYN3hjzmnt4FtS4Phv4phN05IxbrXO72/K5+Cax21SpTBAE/R3MM/WYWtmv/ciFlsjjZr8PAwMFEaeWCFrEgPRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213514; c=relaxed/simple;
	bh=BJofGXL/a8HIQ0ik6EwuMNj+GdVVUA30N7oGuFKv8NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmRDEngqDpP3yXjlmf6+q9uueUTzlCSW2HQMWY4Qyz4lKnbHseSFNvzeGKBD5/78vSmSw8tlEFoOxQjJ9vpQqLZ2olFCDiOlkJJOGqOINuK1H7L5/O4JrGcUB9g/o45YX2reV5vafNaTIIs6qGLj27kd7WZI6h8eQZyIbtf8XZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcMqxKfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcMqxKfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADD71F00893;
	Sat, 12 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213511;
	bh=QJNJy+6m7vdCIz2GaWhb6aWGissb67MixihMxNGJri8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcMqxKfozlNQRK0BuG9uABI9z0Os0UxEBHXSNIhc0f93l/BYN4iiWidtGRXfcn7b5
	 tS6S1CJy1hHh3+ToA094ZugcBABcULHTO5XZcF1I15ws1NmB6bFrXaDsDaUErx3NYD
	 IP/KL7WFVn12+bgkJhRj2OJ8bgI12VQbSsLyE2Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Matteo Martelli <matteomartelli3@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0135/1376] iio: adc: pac1921: fix wrong channel used in trigger handler read
Date: Sat, 12 Sep 2026 08:42:41 +0200
Message-ID: <20260912065610.562701136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit 3364c56b20c1c496bdb8c8df32f96a9947dbf98e upstream.

pac1921_trigger_handler() walks the enabled channels with
iio_for_each_active_channel(), which yields the scan index (bit) of each
active channel, while ch is a separate counter used to pack the samples
contiguously into the scan buffer.

The register to read was looked up with the packing counter instead of
the scan index:

	ret = pac1921_read_res(priv, idev->channels[ch].address, &val);

pac1921_channels[] is ordered by scan index, so channels[bit] is the
channel that is actually enabled, whereas channels[ch] is merely the
ch-th array entry. These coincide only when the enabled channels form a
contiguous prefix (e.g. all channels enabled). With a sparse scan mask -
for example when only the power channel (scan index 3) is enabled - the
handler reads the wrong register (VBUS instead of VPOWER) and pushes it
to userspace as the enabled channel's data.

Index the channel array by the scan index (bit) to read the correct
register, keeping ch only for contiguous packing into the scan buffer.

Fixes: 371f778b83cd ("iio: adc: add support for pac1921")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Acked-by: Matteo Martelli <matteomartelli3@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/pac1921.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/pac1921.c
+++ b/drivers/iio/adc/pac1921.c
@@ -1020,7 +1020,7 @@ static irqreturn_t pac1921_trigger_handl
 	iio_for_each_active_channel(idev, bit) {
 		u16 val;
 
-		ret = pac1921_read_res(priv, idev->channels[ch].address, &val);
+		ret = pac1921_read_res(priv, idev->channels[bit].address, &val);
 		if (ret)
 			goto done;
 


