Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051279;
	b=MFAI3/KishuJb9NYV1ra6tBafPkn5c6Fvn2XPTDKNS0khnBpXsoeEfOVXyZyKh3WLPVD
	 2WeKs7t1mmGNgHI3s3Rpkd9uNFJOiG1WPa/mgoxtuvfEv+SUNvQsjYPZnAs7cc5X91Mff
	 edvN4z8F/trMuwD8Fmki/nTH27U9HYvtYVJsUz/hQxBWtAMLKOf6i3b2qhAq6z4IHeLq8
	 iA1mRXyQ+Z87ZbJV5EuVCuqQyCVFq3XlmLEn3YrGlYLT4kEgPt8lQbODezsfhNKkP9Idj
	 w31IVTk7TuUkVqpLAbwlPQxbxBPSo5JMq6d6VcJuzWjNoFYn0yBHTWO+LDPEs22DZKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DE/uDcS/1D+OiqUWJS29bYqQhfU2lzhNcvqzzAi+fR4=;
	b=vVju+FE2aeSI9wXEA1gzrfeJRHgSH7kS9mDcVCcnQb1T42eIpyDCYkuJNThtTxm3P4P/
	 t8KUDZGmt6BkSyIYzqQhUMGeLGdbF8YIU84oyd+cuNldWSyY4JF5sRWox2OTt6KH9iK55
	 vxMtMoN0BiAfBuPHb5gE/pPQ3WNFtQgCaMVU9xPcgQW4UQCrvx96KdlFajFuJcdIONOKz
	 wFCw48VDoniVQzinGKZbzY2Xwi3DehyggotfPQl1/WyS9xrQcw2ruFv5B5n/vTR9Iddjw
	 qv7VFncA5UFu9e9Yk1TkWNg3KapiSLnMyUYqiInNjZVFMBoIF/PypSVxuA4icRsXt1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H2TPV0Zu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F017606A31C;
	Thu, 19 Nov 2026 01:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H2TPV0Zu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713A41F000C4;
	Thu, 19 Nov 2026 01:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051279;
	bh=DE/uDcS/1D+OiqUWJS29bYqQhfU2lzhNcvqzzAi+fR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2TPV0ZuGCn6UzgT8gI3N7TlREWs5Xj3pWKm2AyMQYM/YYgUzMjIhxnjCswa8zOia
	 hdAAlU6+44szIa1VdDeAzEv0QaodOOwUdzc2W5UXhGOMKNQDjf+TtYsH16xlGsPoXP
	 epG94W18SGGvWHyClBGBFhqOwseYctMkTppGgwWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0152/2214] fs/ntfs3: Fix memory leak in indx_find_sort()
Date: Wed, 18 Nov 2026 15:30:28 +0100
Message-ID: <20261118150016.231045782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 194491be54e1c9e4d29d3ee777b05ff031c4b670 ]

When popping a level from the index lookup stack, indx_find_sort() frees
the struct indx_node but not the index buffer it owns. Every call that
descends and then pops a level leaks that allocation.

Free n->index before freeing the node itself.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index dc0ebc6e30c00..4b3b266c4bc3e 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1332,6 +1332,7 @@ int indx_find_sort(struct ntfs_index *indx, struct ntfs_inode *ni,
 		/* Pop one level. */
 		if (n) {
 			fnd_pop(fnd);
+			kfree(n->index);
 			kfree(n);
 		}
 
-- 
2.53.0



