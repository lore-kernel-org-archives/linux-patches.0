Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184342EBB8D;
	Tue, 21 Jul 2026 20:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667412; cv=none; b=nLtsYAzwj7F6nGY8BqwauRF2Nda5vUx24/6CiI9HiBqnd6Il8glLgZOtvUrrHH7ymdApI0pGVLSa5pE+oNkQVBOEnE2bonvtiZ22OG5zsaJXmYkfyq/BKDqOE7PX2iZQjwy5auiXG0RD9REBbQuvS+2GvNpp8EDhnMzP7Gg7NBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667412; c=relaxed/simple;
	bh=sIkC9w4iXs3cOnlPfIOhBYHpEKTrcABBXGBBNE092BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDQUlZZEho8J/4/wc4rn2qHrg5xIJ+xcqoiZP+Mom8CNO/BHEsmsX9lQaekozpAtsy2Kbpdksq+IpG58WrWJYEBv8v9t81aOn18NSK7GwDbQy9Nn7gv8Ds1h9XdNTGRJJTjFgBTuK4zxdr/wgE7qgj9WzhRQcLhynYjUxTM75yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADjifQTi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADjifQTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7F81F000E9;
	Tue, 21 Jul 2026 20:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667411;
	bh=yMutYvlqoeGyFI9iLf8cMKsCIyGGurooSrErjnvda8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADjifQTiorZD5KZMQbxUablMXVvQOfdRjNC1SQcwSiIe9L9X04hUVs9BBkAorJ52V
	 Rnmm9vuHCQ3rcoSrarvG8rha6gFbLFfeYhCEVqdl94sgs9yOuhIAviZ3rg36sU2Qww
	 bRBkDHQ/S8I3PXqzR74rOxEpHDV/oplAbnK+Qn8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 1050/1266] dm-stats: fix dm_jiffies_to_msec64
Date: Tue, 21 Jul 2026 17:24:47 +0200
Message-ID: <20260721152505.314157801@linuxfoundation.org>
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
@@ -833,10 +833,10 @@ static unsigned long long dm_jiffies_to_
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


