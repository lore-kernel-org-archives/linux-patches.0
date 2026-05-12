Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A3F3ADB9A;
	Tue, 12 May 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608566; cv=none; b=gjVC+KfiVsnqa7VVX7L3o3Bgi1FnhogHS2QO8CHirk7RfYulkpB63y0HxZWaSEHYTWkInzvloBs2SrYSqNX6Tc1zuOFq2S8Uldx6VqkTvek404nChCOrbPH9vBJFtF0zaCFzK5zmVHJVvpLOz1MomtWFgpBSxLfhyYoSdknUHAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608566; c=relaxed/simple;
	bh=b6FQaytxvETOQKhGJEM1U1BWrSjzwEyixYgKaw9wv/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoUOx7FMuKZ6MuDY32UHpEtq3whiHSoD2LUeu17S6gZyRwafmrCf12QgizVJJfvIEAJV3N00cIHP2wMeWf0doM9atrGoJ4CC2a1OddYhBj3z3BicRP5EYxw35FTuhlJI20eussqMegiP1AvUBGMY6hzBVRiqJ5aJgVgEdphYx/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXK0sPOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXK0sPOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFC1C2BCB0;
	Tue, 12 May 2026 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608566;
	bh=b6FQaytxvETOQKhGJEM1U1BWrSjzwEyixYgKaw9wv/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXK0sPOu1G9cS+JSxpL0rtkzjZLkwsqilpwSBOGz7RLfliDCtvXljOQSvyqQjnbaQ
	 cooTYXTFNHNg4fGvtFJGJQAK40LqRnes4MAc7Je9Jyv5vwKS66eNPHWwslzAhz+gjW
	 MXuxSmF0yzu7fmxyyC5L4ctwWdNqmY5xDcz7LawM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 122/270] hv_sock: fix ARM64 support
Date: Tue, 12 May 2026 19:38:43 +0200
Message-ID: <20260512173941.024890319@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

commit b31681206e3f527970a7c7ed807fbf6a028fc25b upstream.

VMBUS ring buffers must be page aligned. Therefore, the current value of
24K presents a challenge on ARM64 kernels (with 64K pages). So, use
VMBUS_RING_SIZE() to ensure they are always aligned and large enough to
hold all of the relevant data.

Cc: stable@vger.kernel.org
Fixes: 77ffe33363c0 ("hv_sock: use HV_HYP_PAGE_SIZE for Hyper-V communication")
Tested-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260428125339.13963-1-hamzamahfooz@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/hyperv_transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -375,10 +375,10 @@ static void hvs_open_connection(struct v
 	} else {
 		sndbuf = max_t(int, sk->sk_sndbuf, RINGBUFFER_HVS_SND_SIZE);
 		sndbuf = min_t(int, sndbuf, RINGBUFFER_HVS_MAX_SIZE);
-		sndbuf = ALIGN(sndbuf, HV_HYP_PAGE_SIZE);
+		sndbuf = VMBUS_RING_SIZE(sndbuf);
 		rcvbuf = max_t(int, sk->sk_rcvbuf, RINGBUFFER_HVS_RCV_SIZE);
 		rcvbuf = min_t(int, rcvbuf, RINGBUFFER_HVS_MAX_SIZE);
-		rcvbuf = ALIGN(rcvbuf, HV_HYP_PAGE_SIZE);
+		rcvbuf = VMBUS_RING_SIZE(rcvbuf);
 	}
 
 	chan->max_pkt_size = HVS_MAX_PKT_SIZE;


