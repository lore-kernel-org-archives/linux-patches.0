Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB1C436BC6;
	Tue, 21 Jul 2026 19:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663926; cv=none; b=PvTBwJhp45qs/mrA4163kEdPuUfuO4+rW/vC3PUFXIGMgDPvZJzOU0TlAZEZ4hAKcX0Wyq6lhXP56GorBTl6nfVfktJhfyoE6gByXj5iy6wWH8Rt67/E+j+Z3A/n0DHgBiDhp6yaD0TMJQfjeA29SD/6gQtDp0HNVymiDLNEkiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663926; c=relaxed/simple;
	bh=OzXvYgY+vHjodmjW/Kupjx9XQH5NoLauybvo0tYVizk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lA48wLwQWP6V6LjTL0ln9YAnXsnbWPqRtC/M2g0w22DoJiIXn+eguCJ4OBANp7B/MVpAgE2btAQTo1Ul0LxdZahWF8+EzzqX0sn+b6DYRZqaYSA2BrNnai69t9rTI9O5I7cfW9Q+4eu5Qp0cCzCzO+NR+mh3rxRTvpLEV3NzDX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ev0LsX+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ev0LsX+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FA91F000E9;
	Tue, 21 Jul 2026 19:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663924;
	bh=jjImNVE8eIenrdquO8fJSTdX8eLxJUR120D+q4cITxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ev0LsX+e0NNbYu3KTHuhGimSM09Rk7DIiGdVAE5DxwI/RiNW1Ado94049+2EjEUAS
	 801LC1fmP5UmasCpnVTZC3dryuBNA8eRBw85VkrmTbvlBw8hRCY9o7fCFjtXxK2ipx
	 Rdt2AKpeGLSHvRQngbu8H89MCrdq6EWXTCjZirlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1006/1276] dm-stats: fix dm_jiffies_to_msec64
Date: Tue, 21 Jul 2026 17:24:09 +0200
Message-ID: <20260721152508.521893122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


