Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F89A1D545;
	Thu, 23 May 2024 13:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470818; cv=none; b=hEOb66u9XNiqWx8XZQisO2k8tc3924YOlZLpOZRuDmfA/0rJU/Fxgl27Ixk0nS1Lz+caAYXGhyLxx1MsiBdnk0mh4FQEaD4CcdW3qktvzcbgv9dq6SJuU9g45r76xbQwT1vPBe18tg5D7kOXuKGbwY4fSDPtnZ+oGe37IxGIarA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470818; c=relaxed/simple;
	bh=6MGMmRKuaW2O2CwZpRUHvufrp/4DcvjACrn4Jnj5Ja0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lr7lx2ZYoF7JPJ4K33PNwODs17mB6KNuhO0V9145Lhv5ZqsEmvQe3MkvKVePuH2L3/eqrW74uUV/b8GpJrYVoIQT40u1dKVvBwJx6yPY0UPfuowFTGii9P2NhpEdbBEfY7nQHPBl4FC2WEPwKaMsuzqS+ot5W5KrkTMn2RTJoss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgSob3KZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgSob3KZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE232C2BD10;
	Thu, 23 May 2024 13:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470818;
	bh=6MGMmRKuaW2O2CwZpRUHvufrp/4DcvjACrn4Jnj5Ja0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgSob3KZXX+pX13b+8hgc3NMVPY0vFE0oMJQYdmNdovUJuYwFoMnwHtRA/4VM4tl4
	 eYdS3FynoMG+RVO2FC+84y16+xQ2QEN4VLLv3qnWVMAN38ROZdgd6qXwU8keFkGg6H
	 5JF7x7oD/uTVlbHLzQJyiJ0m6tve/SEE2u3+FA2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.6 099/102] docs: kernel_include.py: Cope with docutils 0.21
Date: Thu, 23 May 2024 15:14:04 +0200
Message-ID: <20240523130346.208271961@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Akira Yokosawa <akiyks@gmail.com>

commit d43ddd5c91802a46354fa4c4381416ef760676e2 upstream.

Running "make htmldocs" on a newly installed Sphinx 7.3.7 ends up in
a build error:

    Sphinx parallel build error:
    AttributeError: module 'docutils.nodes' has no attribute 'reprunicode'

docutils 0.21 has removed nodes.reprunicode, quote from release note [1]:

  * Removed objects:

    docutils.nodes.reprunicode, docutils.nodes.ensure_str()
        Python 2 compatibility hacks

Sphinx 7.3.0 supports docutils 0.21 [2]:

kernel_include.py, whose origin is misc.py of docutils, uses reprunicode.

Upstream docutils removed the offending line from the corresponding file
(docutils/docutils/parsers/rst/directives/misc.py) in January 2022.
Quoting the changelog [3]:

    Deprecate `nodes.reprunicode` and `nodes.ensure_str()`.

    Drop uses of the deprecated constructs (not required with Python 3).

Do the same for kernel_include.py.

Tested against:
  - Sphinx 2.4.5 (docutils 0.17.1)
  - Sphinx 3.4.3 (docutils 0.17.1)
  - Sphinx 5.3.0 (docutils 0.18.1)
  - Sphinx 6.2.1 (docutils 0.19)
  - Sphinx 7.2.6 (docutils 0.20.1)
  - Sphinx 7.3.7 (docutils 0.21.2)

Link: http://www.docutils.org/RELEASE-NOTES.html#release-0-21-2024-04-09 [1]
Link: https://www.sphinx-doc.org/en/master/changes.html#release-7-3-0-released-apr-16-2024 [2]
Link: https://github.com/docutils/docutils/commit/c8471ce47a24 [3]
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/faf5fa45-2a9d-4573-9d2e-3930bdc1ed65@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/kernel_include.py |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/sphinx/kernel_include.py
+++ b/Documentation/sphinx/kernel_include.py
@@ -97,7 +97,6 @@ class KernelInclude(Include):
         # HINT: this is the only line I had to change / commented out:
         #path = utils.relative_path(None, path)
 
-        path = nodes.reprunicode(path)
         encoding = self.options.get(
             'encoding', self.state.document.settings.input_encoding)
         e_handler=self.state.document.settings.input_encoding_error_handler


