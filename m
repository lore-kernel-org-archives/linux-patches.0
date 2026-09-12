Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA403624BC;
	Sat, 12 Sep 2026 10:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207294; cv=none; b=QPu1bIStMzZt95epo/FCIE9+s/9x40ReqHpa9FD9CYHM25m0fsjnOXvTyU5WIQQ8w0aYTLOJH1JjK4lOj8+DAQkG1reqioe+m2OWlesMtv5G6D50AiNUHX35+L7HY9Qfbva27fVbX90hpvo+sOYxC4113uTlW8ILR9P4/A0iGWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207294; c=relaxed/simple;
	bh=+ZAQl5nXedGFPbM0Du/KrNdbA/7i9s92NqKhP3jw8Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKYQNohh1DYgiZDHEMeWe0GypHr7Ctrz1I/zl6rHi0JLFxYSFHICCWwVHzyla1CGioopxYaa2p9VHuMelb7nrCUI1aM1UQ75SRsLtBhdTlpdvAH7VfJB82dfW6J1CBoCG9TeFydzIwvWxEwQhdLjA6Neyj4TzS6v37w4pfH9AVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihvx9Bpq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihvx9Bpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858821F000FF;
	Sat, 12 Sep 2026 10:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207293;
	bh=p1SkiVeAyFVadcqeICbtRUxzakEcSYBW2LVGVFOtYlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihvx9BpqfTqD+I4f18vz+cdV2+HIYk58Mb8+hNgqIxHxvku9tsh3MRtf7WTrD8tKK
	 /PUwESppkayVc8iI7OwFgARTFhEkETvcx9MdhZ7I8QCgJePq5Y445Pbu+07WMPjuds
	 RHnwov2aIXkU2yPCHzngvbVWpHSKqCzW5ad6ju3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0384/1518] firmware: arm_scmi: Use channel ID for transport teardown
Date: Sat, 12 Sep 2026 08:42:33 +0200
Message-ID: <20260912065632.148388430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit a71a3d4d8a6e9e399fd988c0e6da47a6ee21c99e ]

SCMI protocols can share the BASE transport channel when firmware does
not describe a dedicated channel for the protocol. In that case multiple
IDR entries can point at the same scmi_chan_info, whose owning transport
device was created with cinfo->id.

scmi_chan_destroy() used the IDR iterator key when destroying the
transport device. If an alias entry is visited before the owning channel
entry, the lookup can miss the device because the iterator key does not
match the protocol ID used when the transport device was created. The
code then clears cinfo->dev, so the later owning entry skips teardown and
leaks the transport device.

Destroy the transport device using cinfo->id, which is the protocol ID
that owns the channel and was used when creating the transport device.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-8-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 6fc8129dc8691..c6483b8285ae4 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2807,7 +2807,7 @@ static int scmi_chan_destroy(int id, void *p, void *data)
 		struct scmi_device *sdev = to_scmi_dev(cinfo->dev);
 
 		of_node_put(cinfo->dev->of_node);
-		scmi_device_destroy(info->dev, id, sdev->name);
+		scmi_device_destroy(info->dev, cinfo->id, sdev->name);
 		cinfo->dev = NULL;
 	}
 
-- 
2.53.0



