Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928CE471271;
	Tue, 21 Jul 2026 18:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659108; cv=none; b=rzlGR318kLg4P76V/QHDnt3MwhLY2S8cNnKNlTAHMWL3KdDxWgEfhwoPtFJGpUaXYqJ4RQXr1pZe6YQkzDRpcYrv5GKZh4zPUkykzhnNq7CbMhkSwkq4XGN39k1Gwxl+uhqIIqL1gbnlfy3uBQb4Ftg4tk7K38aKKPIOF6E4nl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659108; c=relaxed/simple;
	bh=321Cf0yu5GPPfScHPlO2Pj0jEhvkbM5YZLxznZPPQuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpQWuIQcAvYzNqPqextVRhpQPOzbaNSN1kTbprTx7GYTK0GGUtzjvf+Mo1QH+tzW0ELTh76JeV4wACuT4RD3JkBA3FdSDNdtPZI57iKrDCJeV5G73V/VKgSzWMGbh+1rVQHxzKZcdoqGr3C6fNpVQl6Fps0psIZwJS3mY5Vw3pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDh+P/pr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDh+P/pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F3B1F00A3F;
	Tue, 21 Jul 2026 18:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659107;
	bh=FcXH47SvlC7V0hQXwHIellHFxIR6RDJMMVejGqLft9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDh+P/prrn6T0LW+7TSMZa+CNOXohoQeltmg3qpiT0Rc10FN1T5yhhFfWaG7Q0Y+T
	 k8ThkmEOwm3bqTPZyZVtxpFb4/mgbG5+guTaG64xXOmZC8sWYge4ZUBCv4Oj4w70tu
	 aj8c0zIgLK56sHJtAc0/yjoBHVU9BR6IPMHYQHZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1352/1611] dm-stats: fix dm_jiffies_to_msec64
Date: Tue, 21 Jul 2026 17:24:28 +0200
Message-ID: <20260721152545.866782443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 386df1a57b631c456d14f857cb0c0c2e11c16bef upstream.

There were wrong calculations in dm_jiffies_to_msec64 that produced
incorrect output when HZ was different from 1000. This commit fixes them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -842,10 +842,10 @@ static unsigned long long dm_jiffies_to_
 		result = jiffies_to_msecs(j & 0x3fffff);
 	if (j >= 1 << 22) {
 		mult = jiffies_to_msecs(1 << 22);
-		result += (unsigned long long)mult * (unsigned long long)jiffies_to_msecs((j >> 22) & 0x3fffff);
+		result += (unsigned long long)mult * ((j >> 22) & 0x3fffff);
 	}
 	if (j >= 1ULL << 44)
-		result += (unsigned long long)mult * (unsigned long long)mult * (unsigned long long)jiffies_to_msecs(j >> 44);
+		result += (unsigned long long)mult * (unsigned long long)(1 << 22) * (j >> 44);
 
 	return result;
 }


