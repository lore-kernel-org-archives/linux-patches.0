Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626284;
	b=YZMijz1cvE+FOsJLT0b3lzi8v/c/23xcrbIPXRTeO8OwHQnTMiXxyzem4yXRlxXOO0yx
	 Dlc0N4sQu3XZKNviufRbDZHfOXttik1t+s1HchNEr+x8El6vHp4EckQvwQC98XYjhVfEE
	 B4Owy7I+W/Lr9VlZTgUTobfGZa8rbi94h2SetxJVTkh/QiruvBkxi3JwSRD43X8tzuIAH
	 /koXT0ZGVmpqYczTLMy5dFR3MP1oOErtfuuwf/Lxcy7Q/wri2brkP5RHJG7UNT6wzWAPh
	 I4WE8zKSCgvlVNoRzgyyEInqihHQwUYy7HDe9tF92E+ZnrZ/zP6CRFFb1G+pVRIqp3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o4Z0HKX0S+ESxb6Sc+1S5qIEtknRY23zXKq+lgmgxhI=;
	b=VH+xEdgfph5vOg+pXocifxLLlktxweu55YOKPaJvccRyYY00z623OOH7gss4owh4/mvN
	 wWoA9AdYhBb3hWZJTPzBR0Czjl+w87uScoLVQaau5iumf4Ofc76wDhmo3KOaVYWIneSAz
	 qZNzJCMCQ0t7JXKjE0dO8HM/0ZAyl+N6EmPVRIpMliHEVrOK8CcQt4kOy2wDbL7/2/Ddo
	 9w/5P/hpICyv8tHLSNQEkz4QR6BMLkh9UqZIbcU4ZJHVlBL8ss29N0/bMFSfg1mo4+cIK
	 xKrR08Uuigre75TdBxFBYAHZW4Y6fGNlQ9IcBu+cV7VQb0cFYHk7lP1gYggdHVh4Klg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ps7hsVu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54425606A31E;
	Wed, 25 Nov 2026 17:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ps7hsVu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E0F1F000C4;
	Wed, 25 Nov 2026 17:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626284;
	bh=o4Z0HKX0S+ESxb6Sc+1S5qIEtknRY23zXKq+lgmgxhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ps7hsVu8Jrlwa4oar7JHUnM3E/4O9u8y4o3EP7lmnHb9jeQH0meBmiXg9gi8bF6AJ
	 ur5vDkL239uBBFCdAOcHqzrLmBmX3fXMB3WlBqjbTLY7RS+Vle6eSMBSRymQZ9EqcA
	 unk08IPD5BnzJuEAJ34AW/a9qWaqOL3TkkQB+xDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 791/816] iio: imu: inv_mpu6050: fix magnetometer scale of Y and Z axes
Date: Wed, 25 Nov 2026 15:38:59 +0100
Message-ID: <20261125143907.481102623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnav Kapoor <kapoorarnav43@gmail.com>

commit e5f7a6684a23d9b20184a81b4ebded3b3504ccdc upstream.

inv_mpu_magn_get_scale() returns st->magn_raw_to_gauss[chan->address],
where magn_raw_to_gauss[] holds one coefficient per axis, computed in
inv_magn_init() from the per-axis factory sensitivity adjustment values
(ASAX, ASAY, ASAZ) of the AK8975/AK8963 magnetometer.

However INV_MPU9X50_MAGN_CHAN() never sets .address, so it is 0 for all
three magnetometer channels. As a result the Y and Z channels report the
scale computed from the X axis adjustment value, and userspace scales
the Y and Z readings with the wrong per-axis calibration.

Set .address to the axis index (0 for X, 1 for Y, 2 for Z) in the
channel macro, matching the order used to fill magn_raw_to_gauss[].

Fixes: b1392de06184 ("iio: imu: inv_mpu6050: add MPU925x magnetometer support")
Signed-off-by: Arnav Kapoor <kapoorarnav43@gmail.com>
Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -1550,6 +1550,8 @@ static const unsigned long inv_mpu_scan_
 		.type = IIO_MAGN,					\
 		.modified = 1,						\
 		.channel2 = _chan2,					\
+		/* index of the axis in magn_raw_to_gauss[] */		\
+		.address = (_chan2) - IIO_MOD_X,			\
 		.info_mask_separate = BIT(IIO_CHAN_INFO_SCALE) |	\
 				      BIT(IIO_CHAN_INFO_RAW),		\
 		.scan_index = _index,					\


