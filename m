Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33FD3BFAF7;
	Sat, 12 Sep 2026 15:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227361; cv=none; b=B/tUHB858OEWqf68K9kmZSxSpFJzKIySHECBE8dP/HRNfhfJgc2yZNnTtSgp8hSF0TTLCSAT/fEtW61uerdvYD6nme2oQBiEAzzBUNls1PJVdc6D4zUK1TmG3GVtQ9VszUicqez+icr+MDYhbyoUKYFg1f0+VHZzEC8sWLQ3w/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227361; c=relaxed/simple;
	bh=GZmRYHPGjeRO8/oUHPkShzhH0Dl2NRm6wtc6f4RgbwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAYy1u6VMTFcmcdukKVShbEqfwOpifk6WQrGX8mNbX/EStROxB5dV0FsS/fH2rPnMJAPH/k2CWZKbQB6pdbucmGIImTerS7Eflf+h+HuRT+eKSxibWp1l51waQj++XrtKot+n2uNQcHdTy7eVgIGTwPUR7x+g3FCFwLNOM4kzSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPxuIgqh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPxuIgqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99411F000FF;
	Sat, 12 Sep 2026 15:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227360;
	bh=erC6XlK/rGmuZZ//8NoIXo9tUR4sYLqWVdzObbAspTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPxuIgqhAojsi29je/ng+h5CUXT3GJbH/M6t6ZVRFd1x+ePTf+wLr3Q/VYnILkCZi
	 XZBdPG3CG72w2V5eyrUEIhSyzGw3vLIGm7S9tPc4czrya9G09kyggC9sH5o8mlz5up
	 66vgB5ZOcPttMvRIsZoMBYQnSrxK5l/L3QKWJA44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 6.1 0148/1191] orangefs: skip leading spaces before parsing client debug masks
Date: Sat, 12 Sep 2026 08:47:56 +0200
Message-ID: <20260912065551.527590797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit d410cd5303ec59c7cf23dd61423752ce8e9ecb59 upstream.

orangefs_prepare_cdm_array() sizes each client debug keyword buffer
with strcspn(cds_head, " "), but then parses the keyword with %s. The
%s conversion skips leading whitespace, while strcspn() does not.

If a client debug entry starts with a space, the allocation can be sized
for an empty keyword while sscanf() copies the following non-empty token.
This can write past the end of the allocated keyword buffer.

Skip leading spaces before computing the keyword length so the allocation
matches the string parsed by sscanf().

Fixes: f7be4ee07fb7 ("Orangefs: kernel client part 4")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/orangefs-debugfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -529,6 +529,7 @@ static int orangefs_prepare_cdm_array(ch
 		cds_delimiter = strchr(cds_head, '\n');
 		*cds_delimiter = '\0';
 
+		cds_head = skip_spaces(cds_head);
 		keyword_len = strcspn(cds_head, " ");
 
 		cdm_array[i].keyword = kzalloc(keyword_len + 1, GFP_KERNEL);


