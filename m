Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49763246762;
	Tue, 16 Jun 2026 17:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631936; cv=none; b=Me5Xe3OxRheOnapFwLuB+M491cpA4lgDqpalRrTnYfwic7IYorP4ngTsDFnzfqNMq6STzp19/ablLNlXPIckci1tVNCpvma/j2BwfShB9W/RSd1MwOo8tB+von7PEpVGtbe5uQoJzbGE7ywaU9jXzB4bTQi8slnexMTOz9chK7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631936; c=relaxed/simple;
	bh=/hjyd8mERC9MbjYz8kEXyD+FIt/lvHEyUMWPcFD2Ld8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGjPBvNxzamOEyjV3R162A8ci2+43zwoWwUkvlHKbuoqcGkTdrnf0UgaMIOjy2ViJSl/vdASA4pzg+aR8s2j7QURZ+4mC7CX6RVP4XFICGlbDFoxZQGR7tdIO+4VkNvsxUiON/JLg1wAxWGB9AdNXkayIkEb2lc2g3IELmuNA9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwU9V8iB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwU9V8iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0D81F000E9;
	Tue, 16 Jun 2026 17:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631935;
	bh=C1LTQ3zwHSJaV0jTb+nGUFYUfAGH3tWJq+r0z76G8Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lwU9V8iBVvnQ90OVPEJvKOkEmfSKky770gZ4Mb/ufnUItxEHw+PoMSzq6lC0GgN/p
	 PMvDWt0lzxC9alDGUH1RE3GcMRIrUsxVF9dEDAMKLVQqnNYGlXTlvivPZm3SQK2Pc9
	 F9d21yznmGHFHKb7n/Evvljw4g0T52o76WifO2kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 316/522] thunderbolt: Bound root directory content to block size
Date: Tue, 16 Jun 2026 20:27:43 +0530
Message-ID: <20260616145140.643384477@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 65423079c7420e3dbf9a7aa345c243a3f5752e5d upstream.

__tb_property_parse_dir() does not check that content_offset +
content_len fits within block_len for the root directory case.
When rootdir->length equals or exceeds block_len - 2, the entry
loop reads past the allocated property block.

Add a bounds check after computing content_offset and content_len
to reject directories whose content extends past the block.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -181,6 +181,10 @@ static struct tb_property_dir *__tb_prop
 	if (is_root) {
 		content_offset = dir_offset + 2;
 		content_len = dir_len;
+		if (content_offset + content_len > block_len) {
+			tb_property_free_dir(dir);
+			return NULL;
+		}
 	} else {
 		if (dir_len < 4) {
 			tb_property_free_dir(dir);


