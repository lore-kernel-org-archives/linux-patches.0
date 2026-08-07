Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA292F0C74;
	Fri,  7 Aug 2026 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116338; cv=none; b=IfQwOk/flv1mRydat2EsS8nREMeaSYWdFhUnEnKxrQC+/kNxhnldZT4nOZXOX8U6o+cGFQ3jpEqGmXcpaPEhRu4BgRHPJ2wCUskvm7L/X5YuTLqoBaYcqXKk3Oo78Xbv6FLfIGIyl52lP1n/hiyEIDj+TCts/qESNJ4x9dRJVwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116338; c=relaxed/simple;
	bh=AHtS+TN+tp1YcCiXaBusvIp1ZWcCfSJ5CcooWi+eGY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOmdKypZcxgGqGQszYb6bGy4jf9PhyLReaCFgBR+drFLvmSsvOdTu8k73p1Gvo/COZi4Y28wzKx+KokHU2Q3mmSbxrsyp88w/OcbDzWDLw2q8WixDRioxIlFLcEPzzjWEaEAmtrSVvFWiMiW7OjnpCpnDDmqaY1qks4U10Zm4aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gYMX4EM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gYMX4EM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E6F1F000E9;
	Fri,  7 Aug 2026 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116336;
	bh=Q06kWxnniXrrOzdXvlUrNc9nZeyMEbbVPDGqQ0HhatQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gYMX4EMoh5GrZOhwFX6aCbhLMZ93WF5yvBeMB7u6RxbLNi+us4mZWDbPIofaBzUX
	 5KkOs6xpqFfUc1ee1JRWXci1cT4A+m+p57cxWjvdeoWoeLRdF1Fho3APeO8fog0Bj0
	 FQ04LCovEbmIxXk3YG+3cVeh6n+HL7fyEIISn8dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 195/261] drm/amdkfd: Handle invalid event type in CRIU event restore
Date: Fri,  7 Aug 2026 16:39:12 +0200
Message-ID: <20260807143419.576025486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -520,6 +520,9 @@ int kfd_criu_restore_event(struct file *
 
 		ret = create_other_event(p, ev, &ev_priv->event_id);
 		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
 	mutex_unlock(&p->event_mutex);
 


