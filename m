Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0028A35C682;
	Tue, 21 Jul 2026 22:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671816; cv=none; b=SnG2XJn4nQ7imO+ijBcr9kInMVtZACLS5Q3QE10arvymGHXC4+9HqYq7rkAQQL0Z5aTPBaT7UwY4KrwIU/r+5vGypMugItZOPZLsJTDb6nJkJNegEvA7Ely60YtZuzrxUV3EeTQoBQ7EupCfFP+PD61lBS1omBZyH78LQT4Hr3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671816; c=relaxed/simple;
	bh=MElAU2iG7pqRDEvXl+NNSJb6TO2v3MJ4ajm9MLCvhIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ift3a6+/Ns0bmVfpE+xXoflqFRQplOYSU3UeJ3uBNbdtCoHJgM9HH1C3Q1HGmUSpyMGlTLRy4CQwsgLBfIVaH4JIRMKt1c74Xrk1QnsZQ+kiLJmLaPYj0FYOkmzwObTbIs9msDk6z3mYMS8oN2mN/ELcAeZ3RK8SBNt2MwAyFBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6k6RKV0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6k6RKV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657DA1F000E9;
	Tue, 21 Jul 2026 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671814;
	bh=uQ0+m0qmQbNBBe5zCGcA2HIn3HrTvNe/AOiyJzA1rBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6k6RKV0VzST0CC/39r0rfN4xazBhujoKOvO2wOaIui4R3rZEJRWJRsFSqs0uJVZL
	 RVswfVEp1jjFB49QOCGaJorzhq3ftK5x/NF5Wx0e1wH4q+yKKNKi7dGVrzuLjjMty/
	 Jlzif5vqgcexr7Nv08T8182WkmsRL5QQcK9XxdXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 388/843] iio: accel: mma8452: handle I2C read error(s) in mma8452_read()
Date: Tue, 21 Jul 2026 17:20:23 +0200
Message-ID: <20260721152414.767362297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

[ Upstream commit 5bdff291d20c31b365d9ddfe9c426fbfb41da5bb ]

Currently, If i2c_smbus_read_i2c_block_data() fails but
mma8452_set_runtime_pm_state() succeeds, mma8452_read() returns 0.

As a result, the caller mma8452_read_raw() assumes the read was
successful and proceeds to use a buffer containing uninitialized
stack memory.

Add proper checking of the I2C read return value and propagate errors
to the caller.

Fixes: 96c0cb2bbfe0 ("iio: mma8452: add support for runtime power management")
Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index a7168803408f68..aa369bdd9c555b 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -252,6 +252,8 @@ static int mma8452_read(struct mma8452_data *data, __be16 buf[3])
 
 	ret = i2c_smbus_read_i2c_block_data(data->client, MMA8452_OUT_X,
 					    3 * sizeof(__be16), (u8 *)buf);
+	if (ret < 0)
+		return ret;
 
 	ret = mma8452_set_runtime_pm_state(data->client, false);
 
-- 
2.53.0



