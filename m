Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA0A3EB0F5;
	Tue, 16 Jun 2026 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636285; cv=none; b=T84QRloiwTjG+UI1T2anmKnKo3Z8V1wnMj9L4Cub19P/t/qRFjNQZagyVvGUA6RS/YjZ8HilJRJcU9ZQ7TPN1t8ElnEzMmIC+QBkcEnzV4ssNdjysSn8/E9AFdFRGQ0k1F7GZpkUCsnIHRyzodh5pt/b+MIEFeT8rACY7C5YHGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636285; c=relaxed/simple;
	bh=X7bLioWTUmkmdeikqKjwA8qOpTVj8j4JCvFudM3OVAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfRTgUyfrxyYMm4RppreoSlSEQzzkox+//zwUlUNY709A1f5+glfKAFdO+srSzSUszZIGzJF6un0lke+yMBPPn0up0ymVyFWeP2KgMbUOhLittHLPLMJop7M66pyIptQSWy0BnFwHC7IHdfydi6xJUwRKP48T5x+nRP7dooL8Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+JKk1aS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+JKk1aS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6A01F000E9;
	Tue, 16 Jun 2026 18:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636284;
	bh=flUBDC0s9gt/R+iDyfNzlMmqBgl5zIXI08pvDgGLW78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+JKk1aSjv9PN5KzRwOb6Ccytdr92KRCqmB7HR0/4CqykooZTy8wVTd685KLjUMOx
	 B180Cp33ko6T7rHEafzoxlcbqnun2qwXqjS7tEXNdEO+HBP7yVnhkwegov44rslSR+
	 UKtjqD+wCo7QfLmoFi90kJEuHTOQ+BW0Ci7GwoKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 209/342] thunderbolt: Clamp XDomain response data copy to allocation size
Date: Tue, 16 Jun 2026 20:28:25 +0530
Message-ID: <20260616145057.913795945@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 322e93448d908434ae5545660fcbe8f5a7a8e141 upstream.

tb_xdp_properties_request() derives the per-packet copy length from
the response header without checking that it fits in the previously
allocated data buffer.  A malicious peer can set its length field
larger than the declared data_length, causing memcpy to write past
the kcalloc allocation.

Clamp the per-packet copy length so that the cumulative offset
never exceeds data_len.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -355,6 +355,8 @@ static int tb_xdp_properties_request(str
 			}
 		}
 
+		if (req.offset + len > data_len)
+			len = data_len - req.offset;
 		memcpy(data + req.offset, res->data, len * 4);
 		req.offset += len;
 	} while (!data_len || req.offset < data_len);


