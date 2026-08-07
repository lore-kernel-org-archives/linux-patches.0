Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363F0320CB1;
	Fri,  7 Aug 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114426; cv=none; b=FDhZjsmn9MDo9khXwq7WYeSPQ2a8CJr6ODvu1WEFbSjpcwP4JS2/g5WuP+CpP+dITV53NJrzK7paYRIqoBPh5awEC3gH0UTnG2OQMMRDXOIfooG0/+YwPDxKqcteiKEmoz7rpRvP5hQMBnvbJYV467shy0a5n5AX/6YzZnEpmFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114426; c=relaxed/simple;
	bh=lp7qFfNFS1wWF2NA6dPrBj1hPVi8Bq1W/BItsL3kwOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXyM1/WN7opKFXZaQJs8qBp3yWWSaXIEv/1rRiF+OvJTtYaS6SP1J7QBZarKv0qkszIDo8xvcbTbmUxmpHolFph2z5HI8bY1//ZCzF2YYHOJxz715eoKWzceSCkE3PstyS85SjWXSThFmxWk7Gy4cIMOj1rocr3BOEiLvH9doQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4+I1sfQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4+I1sfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD051F000E9;
	Fri,  7 Aug 2026 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114425;
	bh=ZVOqyQ9aoZZeQ0WbnJLz78cMMiGhduXKuOIZ5Mlf1Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4+I1sfQ2fOdQChI0KFJWTkBkqLi00iktJBjBfHOgYyXQdsExaxpSmt9lm7dDZrzl
	 pUHU82Yd0fZ6h+/RYm7RaJaf97bFH2X0pATQ11wpXFZq5eQMkgPtMezzDNjhKfH/n2
	 GmVh5v5OE3wFmTj5u7zxNBn5qDdDiQ/lmLgdLLX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 257/337] drm/amdkfd: Handle invalid event type in CRIU event restore
Date: Fri,  7 Aug 2026 16:37:40 +0200
Message-ID: <20260807143424.118870578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -521,6 +521,9 @@ int kfd_criu_restore_event(struct file *
 
 		ret = create_other_event(p, ev, &ev_priv->event_id);
 		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
 	mutex_unlock(&p->event_mutex);
 


