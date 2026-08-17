Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871703DB324;
	Mon, 17 Aug 2026 15:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980142; cv=none; b=RKTNqK2KylUkbZv9whMmLZ8qu+uDdhUjQKmOV5KgxVNXl4lkYw3OX9V9cz4MKNzBiPV67IBbER9zYCbCCRiQByGjOCr7EwSt8ly6yht1wxIKKJF5vYxiY55oRIjvp6FD0cRDsX7mVVXX6JmtLi26HVhv6vQWIezIzN5HBovVQ5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980142; c=relaxed/simple;
	bh=kgcmvzybCls+k0G0B2GhN9Hoew9G6MxRzdyuFqT1rNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFKEWKPu6czHu1nVVxoM5WOxgRLDyDcDoGoq5+QA1YWjeXlV0DSP/DaPNjKHzKHQ3Ihv4THWZvbL30c08sEPZVq4fZkhr8zjJ5IcJ0PUueM4GfdaviifKawq4XlbQVb8/IURUn2UrWSODeKHh2XK0YHwPj69fkzo/NvbW9IY0go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9GuWmUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9GuWmUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59961F000E9;
	Mon, 17 Aug 2026 15:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980141;
	bh=29+VEYGTQOKJsKmiHHDtjRn4i8e/BRkalhAmbNrfOrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9GuWmUgZy8TiGBeh0Tmxv6A79ISZ1icq83Xz0lLkkgzsHTF4e9AWD4vTtfwLaZlO
	 WKRZ703nQ71GJ2BSjYjpuUEBVRExy5gQ0mzqbRZ3hrJK+wBQVCn0+y5vS18Tfl+OTL
	 dbd+3HBsW6Ex3sg9gNSicjiKjIb1PC0D6wWJXGl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 470/609] drm/amdkfd: Handle invalid event type in CRIU event restore
Date: Mon, 17 Aug 2026 15:32:46 +0200
Message-ID: <20260817132559.707371708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

commit a9cdc85839e4fe2c760aa4ca6cc341c31ad1918a upstream.

In kfd_criu_restore_event, there was no handling for
the event priv data having an invalid event type. The priv
data here is untrusted and can be invalid.

In that case, fail with EINVAL.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2e8e9963cd5c41aa14fd5316bf9ec92e7a0e3097)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -519,6 +519,9 @@ int kfd_criu_restore_event(struct file *
 
 		ret = create_other_event(p, ev, &ev_priv->event_id);
 		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
 	mutex_unlock(&p->event_mutex);
 


