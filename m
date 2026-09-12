Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C3E396B6F;
	Sat, 12 Sep 2026 07:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196710; cv=none; b=CLeOkYtsMs8uBPD5yee/46KALKEQpzDfOp0FNvjJ0zoXSga1Pxk2MQx3uhCpET8wmbZ1rubKD4JU8GSRhexkbfqL6mMQmOLNk/VT5GOWZi/JX4xtUBPl8KbvPqMmz7WO6W1s3DtJW8kz8rOz0anj3IiZL4uJEJIIqPfEFfjGJRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196710; c=relaxed/simple;
	bh=mf3LMAChgrgTYe6llGu0Lmy8p2C1Fh67KAqsosl8Lfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e74P6PI4mp9+C/wqPmJrMRS7zZypeVPQM1pFl+OwZIS+dLcDRDQAzczcc6HCuohdcZ6Ayrs621TXOBzMgX5QoKcQOiToWkCX7KbqfTAT8TAUPTEYADO4EE5b6XHppAkrokEG9QoYjkN6aNVtBi5HGDb2BtajtG/jayr4MNJn7TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3l/auef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3l/auef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C121F000FF;
	Sat, 12 Sep 2026 07:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196708;
	bh=ubsMbN8VvWks1xxbyUnGn82d5+w4tDYXj3aXmxh31Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3l/auefAJCX8I7IjsxtxQr0wuapDRjta69nrU573Dx6c8TsJKW8nO1eH1XblO9qA
	 v27P4Sp0/KS2Zppgze5CTluek6KRVq9bHWIHb6qIJZskUq6buLnhPeARbt29PNDDNF
	 WEumLNqb2UE4gALQiPO7Y6n7Th57qiPWGSe/3I2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Li Chen <me@linux.beauty>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0021/1815] nvdimm: preserve flush callback -ENOMEM
Date: Sat, 12 Sep 2026 08:29:31 +0200
Message-ID: <20260912065649.505460367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <me@linux.beauty>

[ Upstream commit 6b7108712a4b1c37cac69815aede1dde202b3187 ]

nvdimm_flush() maps provider flush failures to -EIO. Keep that default
because provider callbacks can report host-side or backend failures that
should remain generic I/O errors to the guest.

Guest-side allocation failures should not be reported as I/O errors. In the
virtio-pmem path, the flush request allocation can fail with -ENOMEM before
any request is submitted to the host. Mapping that to -EIO makes resource
pressure look like media failure.

Preserve -ENOMEM from provider callbacks and continue to map other non-zero
provider failures to -EIO. The generic flush path still returns 0, and
pmem_submit_bio() already converts errno values to block status for bio
completion.

Suggested-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Li Chen <me@linux.beauty>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260630092338.2094628-2-me@linux.beauty>
Stable-dep-of: e57140944b5a ("nvdimm: virtio_pmem: refcount requests for token lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/region_devs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1093,7 +1093,8 @@ int nvdimm_flush(struct nd_region *nd_re
 	if (!nd_region->flush)
 		rc = generic_nvdimm_flush(nd_region);
 	else {
-		if (nd_region->flush(nd_region, bio))
+		rc = nd_region->flush(nd_region, bio);
+		if (rc && rc != -ENOMEM)
 			rc = -EIO;
 	}
 


