Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AE63BFE5A;
	Tue, 16 Jun 2026 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634296; cv=none; b=HXBjvwl7WqKcaFK6z2weIrEgpKNuQEXVOz+ElgO8zRavcSxlQwxU+ctTqzDU2VG3gPgFvAMdh/Lv/GcwcPwk8n4RLaPnpPi97k0OIqxvSBVXQuZkZEqF4LRoSBo87MAi6cpUxjNRJZlFwoVzV77QnuBFrB7K7cHoEDrJYlVqesI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634296; c=relaxed/simple;
	bh=EEESbb57RYYIaAOX03L8qmHCYLPPFa8adLrSO98mIt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qet89EM42WQVbHSSiSLEvz7KDCveu+dBxmlY2lvE2Ji1bYUs+7DlJee+WhCeuqi10OQBxzwUogeFbNb0Uuw2mqKUOrfmusjZYqwB4m+inbBsa4yLLMlA2c0WLohmT6+Dqq7/fYI2EwYf13dvj96+OVm33KUSUsIQ6Cg99Jlh9EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyHNtr6v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyHNtr6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4193C1F000E9;
	Tue, 16 Jun 2026 18:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634295;
	bh=VBq6broAMIUQ8eucztyTHreQGvwi99mLjUe6tVqyCOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyHNtr6vOYquqKTxgJLv8AML3cfHBUG53YffZvcKNJ87doZpDyNE0qdYGizSxwvk+
	 iihHKkDKYQES1ATHAwVvC/k9AEp/fIrRAh90AoRlG17/h1/ZRFA6BXifUAyYXIlAdn
	 jROWcN/E/wihHOVR9Y3x5izI+c4xWlLJ7cmZdOro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 239/411] thunderbolt: Clamp XDomain response data copy to allocation size
Date: Tue, 16 Jun 2026 20:27:57 +0530
Message-ID: <20260616145113.576154497@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -370,6 +370,8 @@ static int tb_xdp_properties_request(str
 			}
 		}
 
+		if (req.offset + len > data_len)
+			len = data_len - req.offset;
 		memcpy(data + req.offset, res->data, len * 4);
 		req.offset += len;
 	} while (!data_len || req.offset < data_len);


