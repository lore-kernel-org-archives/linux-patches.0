Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590077;
	b=wKSLojomRHq4nKSltGRJKD/t7Ocy1sMsvHY3DOeQPb+7aHMP5yGcWf9t8g8XGZADFZuu
	 1UjzG0j04L0r8gPuIpg+yG1yocOF1kFPEJCa0xpGJEwZUEYpTeN9h3PurFGDO779Z1OGY
	 qvZpYF7rQCqs49QcERX4mpBc1RaSVR0ITOt5IBJuh4bBHhEF/XrRQeg0S5aAHtjBINQxY
	 cop82ethQOp7agsJEvqdodq/26bLNUKiiFlFFlp5CJOsrtCw+rBATGCudmOTqd6ekGxFU
	 8SJk3jDS4mns2w9hmIsp3Mw3ofwxPtw4oQOpEDwbBQV45J6GyGnFVY372U5S06KNyLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UGnDZ0tIlPlWbl8OrtE+gc2akmvi0muInmcAY889o1c=;
	b=03lY+Bu+SsyucdkRmRq1GB97vhTVsWC8M3UftFM9/8YZnxYYc53I6D41sqi+PyFY7ICc
	 wEoQ3wJ5ksRVEbO9O3i4ale34NEoH6wyT0f4Q/hzCWfFAA3mTu7lNBaBn6KsjUMdOepmr
	 B1sCRqty+eUrlLUbtItTBHWsF41c+r82Cdl2Kb/X/KZBD1It6gYHxpVy70ARVQFQxZX3K
	 0x/kmJPl7L5XdvtOjXNV2naM+4KlGT4lasCsrK0ix+LvKrm/qFRaApxTyXbGnx5f0NAfP
	 LiKqiFIZ0eUeBc+tdVGKD93eBI41BCIyE9TnpxYJYKNCF7WxxgS6oXEjdTdf+FOUp8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQjcEzl8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD65606C09D;
	Fri, 13 Nov 2026 17:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQjcEzl8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C9E1F000C7;
	Fri, 13 Nov 2026 17:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590076;
	bh=UGnDZ0tIlPlWbl8OrtE+gc2akmvi0muInmcAY889o1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQjcEzl87cIskDKSB6x/uKDx+bpyGgKDMH1h7C50Ft4DUtgTPz5Ca6eWsz8FboJHL
	 8NLIux+KegtrdjS7nGt6crbAadBy47g/mRtwPSUhziXPwJexd4rbcx4njJWXjw6URO
	 mROyWI8MRKKVS9G9Q05yPoAFoQYWz+hmNOwj07ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/686] bpqether: fix truncated /proc/net/bpqether on partial reads
Date: Fri, 13 Nov 2026 10:44:00 -0500
Message-ID: <20261113153824.479347309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

bpq_seq_start() walks the device list to find the entry at *pos, but
never increments its counter. It returns the first device when *pos is
1 and NULL for any larger value.

The seq_file core calls ->start() with the saved position each time a
read() needs more data, so the listing stops after the first device as
soon as it is not produced in a single pass: when it is read with a
small buffer, or when it is longer than a page.

With five bpq devices, reading the file 64 bytes at a time returned
the header and one device before the change, and all five devices
after.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 0a529c12d374e1dc74c2360e7ca13ab4e594a445)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 209dddef51d06..f30616d915fd3 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -366,6 +366,7 @@ static void *bpq_seq_start(struct seq_file *seq, loff_t *pos)
 	list_for_each_entry_rcu(bpqdev, &bpq_devices, bpq_list) {
 		if (i == *pos)
 			return bpqdev;
+		i++;
 	}
 	return NULL;
 }
-- 
2.53.0



