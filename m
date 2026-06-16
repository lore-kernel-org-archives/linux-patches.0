Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220B8466B70;
	Tue, 16 Jun 2026 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629810; cv=none; b=KbxrghoGQzh5Bfh0ehqXMjrUTyJ+iMJNuL4b7EAZrTzY2edXI98+ZSy/2OGHZhKVdU6/vdWDCa6muraZuCMZo+73mWVY4FhczQ4ZyfKKf0I4Kzdx8Blsi+d0kQ1cOt7ZelXv5OVJNiu1AccTh+0KWN0PopWqTzIj2iGpN9GLIkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629810; c=relaxed/simple;
	bh=rOac8ZBFWM4aL7Gn0Vpq+cvAig3Nigu1CPAS8yWmwQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrW+LyMfxcHZQCb1exS8wRkOW1tke2u+Z7w3fjjM0HlUKFPQSsIUQYwulKNBFgovtP5agr1IpRUjKLuHo9lu/YVUEivk3RHmNON34seKwJu87Kb2up97VwPjE7VPBv9iNkNB6JseEWyySzwdDzTrd/NH4hJySUeFTtYEpqRqa/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyXYioj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyXYioj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DF81F000E9;
	Tue, 16 Jun 2026 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629809;
	bh=K++tXnUchH1Zg59OzRIM4hEPOOQPN9LMSJGaqnXbvG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WyXYioj8Vgck84pGHszZ416LT81bCANEKjV0YtliUWIsJssa4om3dEzTSVEWQCFZt
	 vryCguwofNIIesmB2834ZL3gzXT9KJP8Aq/FbxT9js6aaP9VINPBzjTDSqbu3LkJ0b
	 oHucL9Y9ydtPQ1HsMok7+7TfcZLMH/YJmCIlyZxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 356/452] thunderbolt: Clamp XDomain response data copy to allocation size
Date: Tue, 16 Jun 2026 20:29:43 +0530
Message-ID: <20260616145135.855570035@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -393,6 +393,8 @@ static int tb_xdp_properties_request(str
 			}
 		}
 
+		if (req.offset + len > data_len)
+			len = data_len - req.offset;
 		memcpy(data + req.offset, res->data, len * 4);
 		req.offset += len;
 	} while (!data_len || req.offset < data_len);


