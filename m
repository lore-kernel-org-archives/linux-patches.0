Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4855B13C90B;
	Tue, 25 Jun 2024 09:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308483; cv=none; b=YnKoMfotCWYg1LlHBpTqXHlj+oQbmw6wh6/CDFdCiy+NsZup8WcyG8hcSdFSyFSzcqubFBRdyvPyzQ2ZX2+yT1mNYUUfAN3Q6pR/yKSmZ01df+SCvam3S1aId48n4rxBe3tEgP2q/iZ7dQI12AK0cgN1LOFpAHJeG/DAX8jMsAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308483; c=relaxed/simple;
	bh=9tjio7ghbCv37N5F9PcKoXULlN/AHt0BFvvbBRWEknM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDZd/0GH+VUXkfn1/uG3ybn1isqNCcRNyx6oMW29Dc68w8AhieaQF6z37KOm2vQn7wmLQePHgegfsn86tqS0dSitDN6R7kKbB3ukO2mdNQkqipQvAFDrSxGV0pOc0lYC9mnEE4xDUkupYiWTt1+dYeWktQ9l3/7ZWEHjYOI3u7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0U84RJj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0U84RJj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F8AC32781;
	Tue, 25 Jun 2024 09:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308483;
	bh=9tjio7ghbCv37N5F9PcKoXULlN/AHt0BFvvbBRWEknM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0U84RJj39AtckmnxKYiCxCJYZztyjoba/eBqmiMCaORY+1gEvMp9Bcz2VzH+dUoVW
	 9XKq+OhfTnPFoTehPQ3/z9gTa9b2nbe//XRIdF9s3ntlglP9clcOa0O4wujWt1p6c4
	 tlvZDQRwMoGTpq9AQqaysHmN33vlOFa0IpbmUrwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 129/250] ptp: fix integer overflow in max_vclocks_store
Date: Tue, 25 Jun 2024 11:31:27 +0200
Message-ID: <20240625085553.017180846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 81d23d2a24012e448f651e007fac2cfd20a45ce0 ]

On 32bit systems, the "4 * max" multiply can overflow.  Use kcalloc()
to do the allocation to prevent this.

Fixes: 44c494c8e30e ("ptp: track available ptp vclocks information")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Heng Qi <hengqi@linux.alibaba.com>
Link: https://lore.kernel.org/r/ee8110ed-6619-4bd7-9024-28c1f2ac24f4@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index a15460aaa03b3..6b1b8f57cd951 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -296,8 +296,7 @@ static ssize_t max_vclocks_store(struct device *dev,
 	if (max < ptp->n_vclocks)
 		goto out;
 
-	size = sizeof(int) * max;
-	vclock_index = kzalloc(size, GFP_KERNEL);
+	vclock_index = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!vclock_index) {
 		err = -ENOMEM;
 		goto out;
-- 
2.43.0



